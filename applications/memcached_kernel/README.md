## Memcached Kernel- and DPDK- based real-system benchmark for gem5

### Introduction

This folder contains code for benchmarking memcached with Kernel and DPDK networking to later be used to run traces in gem5. The benchmark contains:
- DPDK client based on both Kernel UDP and DPDK networking stacks;
- configurable KV-store load generator based on zipf distribution;
- DPDK-patched version of memcached server based on [e0e415b](https://github.com/memcached/memcached/commit/e0e415b7b2b43a6ddd01a9c3ad45fb46358d526b);
- patched version of `dpdk_pcap` to capture DPDK traces and store them in standard PCAP format.

### Setup instructions for Kernel stack

* set `USE_DPDK_NETWORKING` to `OFF` within CMake;
* `mkdir build; cd build/; cmake ..; make -j`

This will build Kernel-based KV-load generator (client) which can be used with the standard version of memcached server.

#### Run it
* run *any* memcached server with `memcached -p 0 -U 11211`;
* when stress-testing, add `-m 1024` to run memcached with more memory limit;
* run the client, example cmdline:
    * `./memcached_client --server_ip=10.212.84.119 --batching=16 --dataset_size=5000 --dataset_key_size="10-100-0.9" --dataset_val_size="10-100-0.5" --populate_workload_size=2000 --workload_config="10000-0.8-10000" --check_get_correctness=false`
* the Kernel version of the client does NOT record any trances, use smth like `tcpdump` for this if needed;
* when using `tcpdump`, make sure you run things over the real network (NOT the loopback/localhost) and set the corresponding networking interface in tcpdump's `-i`; do NOT use `-i all`, as this will record traces incompatible with our gem5 loadgen. 


### Setup instructions for DPDK
##### If you are on CloudLab's `d6515`, just run `./setup_cloudlab.sh`

##### Mellanox ConnectX-5 NIC (tested in CloudLab `d6515` instance)
* download DPDK 20.11.3 from here: https://fast.dpdk.org/rel/
    * unpack to, say `dpdk-stable-20.11.3`
* install dependencies:
    * `sudo apt install rdma-core`
    * `sudo apt install libibverbs-dev`
    * `sudo apt install libevent-dev`
* build DPDK:
    * `cd dpdk-stable-20.11.3`
    * `meson setup build`
    * **IMPORTANT**: make sure the `Drivers Enabled` section of the output shows `mlx4, mlx5` drivers in it, otherwise DPDK will fail to detect the NICs
    * `cd build`
    * `ninja`
    * `sudo ninja install`
* build things:
    * export DPDK and RDMA-core library path:
        * `export RTE_SDK=/<FULL_PATH>/dpdk-stable-20.11.3`
        * `export RDMA_CORE=/<FULL_PATH>/rdma-core`
    * enable DPDK build by setting `USE_DPDK_NETWORKING` to `ON` with CMake
    * `mkdir build; cd build; cmake ..`
    * make sure it says it's gonna build the DPDK version
    * `make -j`

This should build both the DPDK-enabled client and the DPDK-patched memcached located at `memcached/` sub-folder of this folder.

#### Run it
* install huge pages:
    * `sudo su`
    * `echo 2048 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages`
* run the just built DPDK-patched memcached server with `sudo memcached/memcached -u root -m 1024`;
* check that it printed the NIC/MAC address information to make sure DPDK is correctly set-up;
* run the client, example cmdline:
    * the only difference with the Kernel stack is the server address is the L2 here:
    * `./memcached_client --server_mac="1c:34:da:41:cb:94" --batching=16 --dataset_size=5000 --dataset_key_size="10-100-0.9" --dataset_val_size="10-100-0.5" --populate_workload_size=2000 --workload_config="10000-0.8" --check_get_correctness=false`
* since Kernel-bypass stacks can not be captured with `tcpdump` in a portable way, use DPDK `pdump` based utility `dpdk_pcap`for this:
    * **after** `memcached_client` is started, run `sudo ./dpdk_pcap -- --pdump 'port=0,queue=*,tx-dev=tx.pcap, rx-dev=rx.pcap'`
    * the captured traces are in the standard PCAP format and can be accessed by tcpdump/wireshark or by a custom PCAP parser.


#### Some results
`key="10-100-0.9", val="10-100-0.9", get/set=0.9`
| Benchmark | Kernel (RPS) | DPDK, ConnectX-5 (RPS) |
| --- | --- | --- |
| batch=1 | 39.7k | 134.6k |
| batch=10 | 124.8k  | 728k |
| batch=100 | 254.2k  | 1.3M |
| batch=128 | 224.5k  | 1.47M |
