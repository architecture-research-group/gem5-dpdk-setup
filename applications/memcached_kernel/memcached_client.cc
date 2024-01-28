#include <gflags/gflags.h>
#include <memcached_client.h>
#include <zipfian_int_distribution.h>

#include <csignal>
#include <iostream>
#include <map>
#include <random>
#include <tuple>
#include <vector>

DEFINE_string(server_mac, "11:22:33:44:55:66",
              "MAC address of the memcached server.");
DEFINE_string(server_ip, "127.0.0.1", "IP address of the memcached server.");
DEFINE_uint32(server_port, 11211, "UDP port of the memcached server.");
DEFINE_uint32(dataset_size, 2000, "Total size of the dataset");
DEFINE_string(dataset_key_size, "10-100-0.9",
              "Key size in the dataset, format: <min-max-skew>.");
DEFINE_string(dataset_val_size, "100-1000-0.9",
              "Value size in the dataset, format: <min-max-skew>.");
DEFINE_uint32(batching, 8, "Request batching.");
DEFINE_uint32(populate_workload_size, 1000,
              "Size of the sub-set of the dataset used for initial population "
              "of the memcached server.");
DEFINE_string(workload_config, "100-0.9",
              "The workload to execute, format: "
              "<number_of_queries-GET/(SET+GET)>");
DEFINE_bool(check_get_correctness, false,
            "Will check all data byte-by-byte for GETs if enabled. Can "
            "slow-down execution.");

typedef std::vector<std::vector<uint8_t>> DSet;

static constexpr size_t kMaxValSize = 1024;

// To catch Ctl-C.
static volatile bool kCtlzArmed = false;
void signal_callback_handler(int signum) {
  (void)(signum);
  kCtlzArmed = true;
}

// ./memcached_client --server_ip=10.212.84.119 --batching=16
// --dataset_size=5000 --dataset_key_size="10-100-0.9"
// --dataset_val_size="10-100-0.5" --populate_workload_size=2000
// --workload_config="10000-0.8-10000" --check_get_correctness=false
int main(int argc, char *argv[]) {
  gflags::ParseCommandLineFlags(&argc, &argv, true);

  // Register signal handler.
  signal(SIGINT, signal_callback_handler);

  // Init memcached client.
#ifdef _USE_DPDK_CLIENT_
  MemcachedClient client(FLAGS_server_mac, FLAGS_batching);
#else
  MemcachedClient client(FLAGS_server_ip, FLAGS_server_port, FLAGS_batching);
#endif
  int ret = client.Init();
  if (ret)
    return -1;

  // Generate dataset.
  size_t ds_size = FLAGS_dataset_size;
  long unsigned int ksize_min, ksize_max, vsize_min, vsize_max;
  float ksize_skew, vsize_skew;
  sscanf(FLAGS_dataset_key_size.c_str(), "%lu-%lu-%f", &ksize_min, &ksize_max,
         &ksize_skew);
  sscanf(FLAGS_dataset_val_size.c_str(), "%lu-%lu-%f", &vsize_min, &vsize_max,
         &vsize_skew);
  if (vsize_max > kMaxValSize) {
    std::cout << "Value size of " << vsize_max << " is too big\n";
    return -1;
  }
  std::cout << "Generating dataset: #items: " << ds_size
            << ", key distribution: " << ksize_min << "|" << ksize_max << "|"
            << ksize_skew << ", value distribution: " << vsize_min << "|"
            << vsize_max << "|" << vsize_skew << "\n";

  DSet dset_keys;
  DSet dset_vals;
  std::default_random_engine generator;
  zipfian_int_distribution<size_t> k_distribution(ksize_min, ksize_max,
                                                  ksize_skew);
  zipfian_int_distribution<size_t> v_distribution(vsize_min, vsize_max,
                                                  vsize_skew);
  for (size_t i = 0; i < ds_size; ++i) {
    size_t key_len = k_distribution(generator);
    size_t val_len = v_distribution(generator);
    dset_keys.push_back(std::vector<uint8_t>());
    dset_vals.push_back(std::vector<uint8_t>());
    dset_keys.back().reserve(key_len);
    dset_vals.back().reserve(val_len);
    for (size_t j = 0; j < key_len; ++j) {
      dset_keys.back().push_back(std::rand() % 256);
    }
    for (size_t j = 0; j < val_len; ++j) {
      dset_vals.back().push_back(std::rand() % 256);
    }
  }
  std::cout << "Dataset generated.\n";

  // Execute the load.
  std::cout << "Now you can run PCAP trace recorder.\n";
  std::cout << "Press <Ctrl-C> to populate server with the workload...\n";
  while (!kCtlzArmed) {
    sleep(1);
  }
  kCtlzArmed = false;

  // Populate memcached server with the dataset.
  size_t populate_ds_size = FLAGS_populate_workload_size;
  if (populate_ds_size > ds_size) {
    std::cout << "Population dataset is bigger than the main dataset.\n";
    return -1;
  } else {
    std::cout << "Populating memcached server with " << populate_ds_size
              << " first elements from the generated dataset.\n";
  }

  size_t ok_responses_recved = 0;
  size_t batch_cnt = 0;
  for (size_t i = 0; i < populate_ds_size; ++i) {
    client.Set(i, 0, dset_keys[i].data(), dset_keys[i].size(),
               dset_vals[i].data(), dset_vals[i].size());
    ++batch_cnt;

    // Check correctness for batch.
    if (batch_cnt == FLAGS_batching) {
      std::vector<std::pair<uint16_t, MemcachedClient::Status>> set_statuses;
      std::vector<std::pair<uint16_t, std::vector<uint8_t>>> get_statuses;
      client.RecvResponses(&set_statuses, &get_statuses);

      for (auto &s : set_statuses) {
        if (s.second == MemcachedClient::kOK)
          ++ok_responses_recved;
      }

      batch_cnt = 0;
    }
  }
  std::cout << "Server populated with " << populate_ds_size
            << " key-value pairs, "
            << " OK response count: " << ok_responses_recved << "\n";

  // Execute the load.
  std::cout << "If you want a separate trace for the workoad benchark, now it's a good time to start capturing it.\n";
  std::cout << "Press <Ctrl-C> to execute the workload...\n";
  while (!kCtlzArmed) {
    sleep(1);
  }
  // De-register the signal.
  signal(SIGINT, SIG_DFL);

  size_t wrkl_size;
  float wrkl_get_frac;
  sscanf(FLAGS_workload_config.c_str(), "%lu-%f", &wrkl_size, &wrkl_get_frac);
  size_t num_of_unique_sets = ds_size - populate_ds_size;
  std::cout << "Executing workload of #queries: " << wrkl_size
            << ", GET/SET= " << wrkl_get_frac
            << ", unique SET keys: " << num_of_unique_sets << "\n";

  size_t ok_set_responses_recved = 0;
  size_t ok_get_responses_recved = 0;
  batch_cnt = 0;
  std::map<uint16_t, size_t> sent_get_idxs;
  struct timespec wrkl_start, wrkl_end;
  size_t set_cnt = 0;
  clock_gettime(CLOCK_MONOTONIC, &wrkl_start);
  for (size_t i = 0; i < wrkl_size; ++i) {
    float get_set = rand() / (float)RAND_MAX;
    if (get_set < wrkl_get_frac) {
      // Execute GET.
      // Always hit in the cache, i.e. use a populated key.
      size_t random_key_idx = static_cast<size_t>(rand()) % populate_ds_size;
      if (FLAGS_check_get_correctness)
        sent_get_idxs[i] = random_key_idx;
      auto &key = dset_keys[random_key_idx];
      client.Get(i, 0, key.data(), key.size());
    } else {
      // Execute SET.
      // Always miss in the cache, i.e. use an unpopulated key.
      size_t key_idx = populate_ds_size + (set_cnt % num_of_unique_sets);
      client.Set(i, 0, dset_keys[key_idx].data(), dset_keys[key_idx].size(),
                 dset_vals[key_idx].data(), dset_vals[key_idx].size());
    }
    ++batch_cnt;

    // Check correctness for batch.
    if (batch_cnt == FLAGS_batching) {
      std::vector<std::pair<uint16_t, MemcachedClient::Status>> set_statuses;
      std::vector<std::pair<uint16_t, std::vector<uint8_t>>> get_statuses;
      client.RecvResponses(&set_statuses, &get_statuses);

      for (auto &s : set_statuses) {
        // Just ckeck ret. status.
        if (s.second == MemcachedClient::kOK)
          ++ok_set_responses_recved;
      }
      for (auto &g : get_statuses) {
        if (g.second.size() != 0) {
          // Check returned data.
          if (FLAGS_check_get_correctness) {
            size_t ds_idx = sent_get_idxs[g.first];
            if (std::memcmp(dset_vals[ds_idx].data(), g.second.data(),
                            g.second.size()) == 0)
              ++ok_get_responses_recved;
          } else {
            ++ok_get_responses_recved;
          }
        }
      }

      if (FLAGS_check_get_correctness)
        sent_get_idxs.clear();
      batch_cnt = 0;
    }
  }
  clock_gettime(CLOCK_MONOTONIC, &wrkl_end);
  static constexpr long int kBillion = 1000000000L;
  long int wrkl_diff = kBillion * (wrkl_end.tv_sec - wrkl_start.tv_sec) +
                       wrkl_end.tv_nsec - wrkl_start.tv_nsec;
  double wrkl_ns = wrkl_diff / (double)wrkl_size;
  double wrkl_avg_thr = kBillion * (1 / wrkl_ns); // qps

  std::cout << "Workload executed, some statistics: \n";
  std::cout << "   * total requests sent: " << wrkl_size << "\n";
  std::cout << "   * average sending throughput: " << wrkl_avg_thr << " qps\n";
  std::cout << "   * OK SET responses: " << ok_set_responses_recved << "\n";
  std::cout << "   * OK GET responses: " << ok_get_responses_recved << "\n";
  std::cout << "   * OK total responses: "
            << ok_set_responses_recved + ok_get_responses_recved << "\n";

  return 0;
}
