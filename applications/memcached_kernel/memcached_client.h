#ifndef _MEMCACHED_CLIENT_H_
#define _MEMCACHED_CLIENT_H_

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

#include <cassert>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string>
#include <thread>

#ifdef _USE_DPDK_CLIENT_
#include <dpdk.h>
static constexpr uint16_t kMaxBatchSize = kMaxBurstSize;
#else
static constexpr uint16_t kMaxBatchSize = 128;
#endif

#include <helpers.h>

static constexpr size_t kClSize = 64;
static constexpr size_t kMaxPacketSize = 1500;
static constexpr size_t kSockTimeout = 1; // sec.

class MemcachedClient {
public:
  enum Status {
    kOK = 0x0,
    kKeyNotFound = 0x1,
    kKeyExists = 0x2,
    kValueTooLarge = 0x3,
    kInvalidArgument = 0x4,
    kItemNotStored = 0x5,
    kNotAValue = 0x6,
    kUnknownComand = 0x81,
    kOutOfMemory = 0x82,
    kOtherError = 0xff
  };

#ifdef _USE_DPDK_CLIENT_
  // Constructor for DPDK networking.
  MemcachedClient(const std::string &server_mac_addr, uint16_t batch_size)
      : serverMacAddrStr(server_mac_addr), batchSize(batch_size),
        currentBatch(0) {}
#else
  // Constructor for Kernel networking.
  MemcachedClient(const std::string &server_hostname, uint16_t port,
                  uint16_t batch_size)
      : serverHostname(server_hostname), port(port), sock(-1),
        batchSize(batch_size), currentBatch(0) {}
#endif

  ~MemcachedClient() {
#ifndef _USE_DPDK_CLIENT_
    if (sock != -1)
      close(sock);
    for (auto &b : rx_buff)
      std::free(b.second);
    for (auto &b : tx_buff)
      std::free(b.second);
#endif
  }

  int Init() {
    if (batchSize > kMaxBatchSize) {
      std::cerr << "The batching size of " << batchSize << " is too large.\n";
      return -1;
    }
    // Init networking.
#ifdef _USE_DPDK_CLIENT_
    std::cout << "Initializing Kernel-bypass (DPDK) networking" << std::endl;
    int ret = rte_ether_unformat_addr(serverMacAddrStr.c_str(), &serverMacAddr);
    if (ret) {
      std::cerr << "Wrong server MAC address format." << std::endl;
      return -1;
    }

    ret = InitDPDK(&dpdkObj);
    if (ret) {
      std::cerr << "Failed to initialize network!" << std::endl;
      return -1;
    }
#else
    std::cout << "Initializing Kernel (socket) networking" << std::endl;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_port = htons(port);
    if (inet_pton(AF_INET, serverHostname.c_str(), &(serverAddress.sin_addr)) <=
        0) {
      std::cerr << "Invalid address or address not supported." << std::endl;
      return -1;
    }

    std::cout << serverHostname.c_str() << "\n";

    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock == -1) {
      std::cerr << "Failed to create socket." << std::endl;
      return -1;
    }

    // Set recv. timeout on sock.
    struct timeval tv;
    tv.tv_sec = kSockTimeout;
    tv.tv_usec = 0;
    if (setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)) < 0) {
      std::cerr << "Faile to set socket timeout." << std::endl;
      return -1;
    }

    // Init buffers.
    for (uint16_t i = 0; i < batchSize; ++i) {
      uint8_t *tx_buff_ =
          static_cast<uint8_t *>(std::aligned_alloc(kClSize, kMaxPacketSize));
      assert(tx_buff_ != nullptr);
      tx_buff.push_back(std::make_pair(0, tx_buff_));

      uint8_t *rx_buff_ =
          static_cast<uint8_t *>(std::aligned_alloc(kClSize, kMaxPacketSize));
      assert(rx_buff_ != nullptr);
      rx_buff.push_back(std::make_pair(0, rx_buff_));
    }
#endif

    return 0;
  }

  int Set(uint16_t request_id, uint16_t sequence_n, const uint8_t *key,
          uint16_t key_len, const uint8_t *val, uint32_t val_len) {
    // std::cout << "SET: \n";
    // for (int i=0; i<key_len; ++i)
    //   std::cout << (int)(*(key + i)) << " ";
    // std::cout << "  |  ";
    // for (int i=0; i<val_len; ++i)
    //   std::cout << (int)(*(val + i)) << " ";
    // std::cout << "\n";

    int res = BatchOrAllocate();
    if (res)
      return res;

    res = FormSet(request_id, sequence_n, key, key_len, val, val_len);
    if (res)
      return res;

    return BatchOrSend();
  }

  int Get(uint16_t request_id, uint16_t sequence_n, const uint8_t *key,
          uint16_t key_len) {
    int res = BatchOrAllocate();
    if (res)
      return res;

    res = FormGet(request_id, sequence_n, key, key_len);
    if (res)
      return res;

    return BatchOrSend();
  }

  // Receive a batch of responses;
  // Returns statuses for each SET and data for each GET in
  // combination with the request_id.
  void RecvResponses(
      std::vector<std::pair<uint16_t, Status>> *set_statuses,
      std::vector<std::pair<uint16_t, std::vector<uint8_t>>> *get_data) {
    uint16_t total_recv_n = 0;

    while (total_recv_n < batchSize) {
      // Parse responses.
      uint16_t recv_n = static_cast<uint16_t>(Recv());
      for (uint16_t i = 0; i < recv_n; ++i) {
#ifdef _USE_DPDK_CLIENT_
        rte_mbuf *mbuf = GetNextDPDKRxBuffer(&dpdkObj);
        assert(mbuf != nullptr);
        uint8_t *rx_buff_ptr = ExtractPacketPayload(mbuf);
#else
        assert(recv_n == batchSize);
        uint8_t *rx_buff_ptr = rx_buff[recv_n - 1].second;
#endif

        uint16_t request_id, sequence_n;
        size_t h_size = HelperParseUdpHeader(
            reinterpret_cast<const MemcacheUdpHeader *>(rx_buff_ptr),
            &request_id, &sequence_n);
        rx_buff_ptr += h_size;

        const RespHdr *rsp_hdr = reinterpret_cast<const RespHdr *>(rx_buff_ptr);
        if (rsp_hdr->magic != 0x81) {
          std::cerr << "Wrong response received: "
                    << static_cast<int>(rsp_hdr->magic) << "\n";
          continue;
        }

        Status status =
            static_cast<Status>(rsp_hdr->status[1] | (rsp_hdr->status[0] << 8));

        if (rsp_hdr->opcode == 0x01) {
          // SET.
          set_statuses->push_back(std::make_pair(request_id, status));
        } else if (rsp_hdr->opcode == 0x00) {
          // GET.
          get_data->push_back(
              std::make_pair(request_id, std::vector<uint8_t>()));
          if (status == Status::kOK) {
            uint32_t val_len;
            size_t rh_size = HelperParseRspHeader(rsp_hdr, &val_len);
            rx_buff_ptr += rh_size;

            get_data->back().second.resize(val_len);
            std::memcpy(get_data->back().second.data(), rx_buff_ptr, val_len);
          }
        } else {
          // Weird opcode.
          std::cerr << "Wrong response received: unexpected opcod.\n";
          continue;
        }

#ifdef _USE_DPDK_CLIENT_
        FreeDPDKPacket(mbuf);
#endif
      }
      total_recv_n += recv_n;
    }
  }

private:
#ifdef _USE_DPDK_CLIENT_
  // We only need the MAC address for the DPDK stack.
  std::string serverMacAddrStr;
  rte_ether_addr serverMacAddr;

  // Main object storing DPDK-related low-level information.
  DPDKObj dpdkObj;

#else
  // Full Linux UDP/IP stack here.
  std::string serverHostname;
  sockaddr_in serverAddress;
  uint16_t port;

  // Just a UNIX socket.
  int sock;

  // Buffers to keep data.
  std::vector<std::pair<size_t, uint8_t *>> rx_buff;
  std::vector<std::pair<size_t, uint8_t *>> tx_buff;

#endif

  // Batching.
  uint16_t batchSize;
  uint16_t currentBatch;

  int FormSet(uint16_t request_id, uint16_t sequence_n, const uint8_t *key,
              uint16_t key_len, const uint8_t *val, uint32_t val_len) {
#ifdef _USE_DPDK_CLIENT_
    // Get packet buffer.
    struct rte_mbuf *pckt = GetNextDPDKTxBuffer(&dpdkObj);
    if (pckt == nullptr) {
      std::cerr << "Failed to get tx buffer for the packet.\n";
      return -1;
    }

    uint8_t *tx_buff_ptr = ExtractPacketPayload(pckt);
#else
    uint8_t *tx_buff_ptr = tx_buff[currentBatch].second;
#endif

    // Form memcached UDP header.
    size_t h_size =
        HelperFormUdpHeader(reinterpret_cast<MemcacheUdpHeader *>(tx_buff_ptr),
                            request_id, sequence_n);
    tx_buff_ptr += sizeof(MemcacheUdpHeader);

    // Form request header.
    size_t rh_size = HelperFormSetReqHeader(
        reinterpret_cast<ReqHdr *>(tx_buff_ptr), key_len, val_len);
    tx_buff_ptr += sizeof(ReqHdr);

    // Fill packet: extra, unlimited storage time.
    uint32_t extra[2] = {0x00, 0x00};
    std::memcpy(tx_buff_ptr, extra, kExtraSizeForSet);
    tx_buff_ptr += kExtraSizeForSet;

    // Fill packet: key.
    std::memcpy(tx_buff_ptr, key, key_len);
    tx_buff_ptr += key_len;

    // Fill packet: value.
    std::memcpy(tx_buff_ptr, val, val_len);

    // Check total packet size.
    uint32_t total_length = h_size + rh_size;
    if (total_length > kMaxPacketSize) {
      std::cerr << "Packet size of " << total_length << " is too large\n";
      return -1;
    }

#ifdef _USE_DPDK_CLIENT_
    AppendPacketHeader(&dpdkObj, pckt, &serverMacAddr, total_length);
#else
    tx_buff[currentBatch].first = total_length;
#endif

    return 0;
  }

  int FormGet(uint16_t request_id, uint16_t sequence_n, const uint8_t *key,
              uint16_t key_len) {
#ifdef _USE_DPDK_CLIENT_
    // Get packet buffer.
    struct rte_mbuf *pckt = GetNextDPDKTxBuffer(&dpdkObj);
    if (pckt == nullptr) {
      std::cerr << "Failed to get tx buffer for the packet.\n";
      return -1;
    }

    uint8_t *tx_buff_ptr = ExtractPacketPayload(pckt);
#else
    uint8_t *tx_buff_ptr = tx_buff[currentBatch].second;
#endif

    // Form memcached UDP header.
    size_t h_size =
        HelperFormUdpHeader(reinterpret_cast<MemcacheUdpHeader *>(tx_buff_ptr),
                            request_id, sequence_n);
    tx_buff_ptr += sizeof(MemcacheUdpHeader);

    // Form request header.
    size_t rh_size = HelperFormGetReqHeader(
        reinterpret_cast<ReqHdr *>(tx_buff_ptr), key_len);
    tx_buff_ptr += sizeof(ReqHdr);

    // Fill packet: key.
    std::memcpy(tx_buff_ptr, key, key_len);

    // Check total packet size.
    uint32_t total_length = h_size + rh_size;
    if (total_length > kMaxPacketSize) {
      std::cerr << "Packet size of " << total_length << " is too large\n";
      return -1;
    }

#ifdef _USE_DPDK_CLIENT_
    AppendPacketHeader(&dpdkObj, pckt, &serverMacAddr, total_length);
#else
    tx_buff[currentBatch].first = total_length;
#endif
    return 0;
  }

  // Append to a batch or allocate a new batch.
  int BatchOrAllocate() {
#ifdef _USE_DPDK_CLIENT_
    if (currentBatch == 0) {
      if (AllocateDPDKTxBuffers(&dpdkObj, batchSize)) {
        std::cerr << "Failed to allocate packets for tx." << std::endl;
        return -1;
      }
    }
#endif
    return 0;
  }

  // Append to a batch or send the batch.
  int BatchOrSend() {
    // Check if the batch is full and send.
    if (currentBatch < batchSize - 1) {
      ++currentBatch;
    } else {
      // Send it.
      int res = Send();
      currentBatch = 0;
      if (res != 0)
        return res;
    }
    return 0;
  }

  int Send() {
#ifdef _USE_DPDK_CLIENT_
    int ret = SendBatch(&dpdkObj);
    if (ret) {
      std::cerr << "Failed to send data to the server." << std::endl;
      return -1;
    }
#else
    for (uint16_t i = 0; i < batchSize; ++i) {
      ssize_t bytesSent = sendto(
          sock, tx_buff[i].second, tx_buff[i].first, MSG_CONFIRM,
          (const struct sockaddr *)&serverAddress, sizeof(serverAddress));
      if (bytesSent != tx_buff[i].first) {
        std::cerr << "Failed to send data to the server." << std::endl;
        return -1;
      }
    }
#endif

    return 0;
  }

  // This is a blocking call.
  int Recv() {
#ifdef _USE_DPDK_CLIENT_
    int pckt_n = 0;
    while (pckt_n == 0) {
      pckt_n = RecvOverDPDK(&dpdkObj);
    }
    return pckt_n;
#else
    for (uint16_t i = 0; i < batchSize; ++i) {
      sockaddr_in serverAddress_rvc;
      socklen_t len;
      recvfrom(sock, rx_buff[i].second, kMaxPacketSize, 0,
               (struct sockaddr *)&serverAddress_rvc, &len);
    }
    return batchSize;
#endif
  }
};

#endif
