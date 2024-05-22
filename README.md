# Userspace Networking in gem5

This documentation contains instructions, benchmarks, and files for running unmodified Intel&reg; Data Plane Development Kit (DPDK) in gem5 simulator.

There are three shortcomings in current architectural simulators with respect to evaluating future networked systesm:
1. Existing simulations have outdated networking subsystem that can at best model a few tens of Gbps network throughput.
2. Existing simulators use slow and sometimes inaccurate load generator applications running on different simulated nodes.
3. There are limited standardized networking benchmark suite tailored for running in simulators with standardized metrics and evaluation methodology.

In this tutorial, we provide detailed steps on how to use a popular kernel-bypass framework Data Plane Development Kit [DPDK](https://www.dpdk.org/) in a state-of-the-art computer architecture simulator [gem5](https://www.gem5.org/).

## System Requirements
- gem5 is supported on Intel, ARM, AMD, Apple M1 architectures
- Test Node (DUT) running DPDK (real system ARM Neoverse N1 CPU)
- Drive Node running pktgen (real system Intel&reg; Sapphire Rapids)
- 100Gbps Mellanox Bluefield ConnectX-5 NIC (Test Node) or any [DPDK-enabled NIC](http://core.dpdk.org/supported/nics/)
- 100Gbps Mellanox Bluefield ConnectX-6 DX NIC (Drive Node) or any [DPDK-enabled NIC](http://core.dpdk.org/supported/nics/)
- If not using devcontainers
  - Install gem5 dependencies. Find [`here`](https://www.gem5.org/documentation/general_docs/building)
  - ```export GIT_ROOT=/path/to/gem5-dpdk-setup```

## Software Information
- gem5 v21.1.0.2  
- dpdk v20.11.03 ([gem5-dpdk](https://github.com/architecture-research-group/gem5-dpdk-setup/tree/main/buildroot/package/dpdk/dpdk-source))  
- dpdk v21.11.0 (ARM Neoverse N1)
- dpdk v23.03 (Intel&reg; Sapphire Rapids CPU)
- pktgen v23.03.0 (Intel&reg; Sapphire Rapids CPU)

## Getting Started
If you are new to gem5 or DPDK, you can visit the gem5 bootcamp [website](https://gem5bootcamp.github.io/gem5-bootcamp-env/modules/introduction/index/) or DPDK [documentation](http://doc.dpdk.org/guides/linux_gsg/) to learn more.

### Installing and setting up gem5
- clone the gem5 respository
```
git clone https://github.com/architecture-research-group/gem5-dpdk-setup
```
- build `gem5.opt` and `gem5.fast`
```
cd gem5
scons build/<ISA>/gem5.fast -j $(nproc)
scons build/<ISA>/gem5.opt -j $(nproc)
```
### Installing DPDK
- Modified DPDK v20.11.3 `(with new benchmarks)` can be found in `/path/to/gem5-dpdk-setup/buildroot/package/dpdk/dpdk-source`
- DPDK v21.11 needed on ARM Neoverse N1
  ```
  cd dpdk-pktgen-build
  ``` 
- Modify the `DPDK_VER` environment variable in `dpdk_pktgen.sh` script (optional)
- source the DPDK installation script (_applies a patch that adds the changes we made to DPDK_)
  ```
  source dpdk_pktgen.sh
  ```
- build DPDK (on real system)
  ```
  install_dpdk
  ```
### Installing Pktgen
- Follow the steps above to install `dpdk` first before you install `pktgen`
- Modify `PKT_VER` environment variable in `dpdk_pktgen.sh` script (optional)
- source the pktgen installation script
  ```
  source dpdk_pktgen.sh
  ```
- download, install, and build pktgen
  ```
  install_pktgen
  ```
We also developed a highly parameterizable load generator model that can run in gem5, sending requests at configurable rates to a server node running in the same simulation instance. 

Please visit the [FAQs](https://github.com/architecture-research-group/gem5-dpdk-setup/wiki/FAQs) in our wiki page if you are having issues.

<!-- The organization of this tutorial is as follows: -->

<!-- gem5-dpdk-setup -->
<!-- ┗ docs -->
<!--   ┣ gem5-dir -->
<!--   ┃ ┣ How to run DPDK in gem5. -->
<!--   ┃ ┃ ┣ TestPMD -->
<!--   ┃ ┃ ┣ L2TouchFwd -->
<!--   ┃ ┃ ┣ L2TouchDrop v
<!--   ┃ ┃ ┗ RxpTx -->
<!--   ┃ ┗ How to run Memcached in gem5 -->
<!--   ┃   ┣ MemcachedKernel -->
<!--   ┃   ┗ MemcachedDpdk -->
<!--   ┗ real-system-dir -->
<!--     ┣ How to run DPDK in real system. -->
<!--     ┃ ┣ TestPMD -->
<!--     ┃ ┣ L2TouchFwd -->
<!--     ┃ ┣ L2TouchDrop -->
<!--     ┃ ┗ RxpTx -->
<!--     ┗ How to run Memcached in real system. -->
<!--       ┣ MemcachedKernel -->
<!--       ┗ MemcachedDpdk -->

## Check out the [wiki page](https://github.com/architecture-research-group/gem5-dpdk-setup/wiki) on how to run:
- DPDK in gem5
- Memcached in gem5
- DPDK in real system
- Memcached in real system

## Authors
- Johnson Umeike
- Siddharth Agarwal
- Nikita Lazarev

## Citation
Please cite our paper if you are using any part of the code for your project
```
Coming up
```
