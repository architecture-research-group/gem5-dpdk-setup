# UserSpace_Networking_in_gem5
This repo contains instructions, benchmarks, and files for running user-space networking in gem5 simulator.

There are three shortcomings in current architectural simulators with respect to evaluating future networked systesm:
- Existing simulations have outdate networking subsystem that can at best model a few tens of Gbps network throughput.
- Existing simulators use load generator applications running on different simulated nodes. This can lead to performances limitations and slow down simulation.
- There are limited standardized networking benchmark suite tailored for running in simulators with standardized metrics and evaluation methodology.

In this tutorial, we provide detailed steps on how to enable a popular kernel-bypass framework Data Plane Development Kit (DPDK) in a state-of-the-art simulator (gem5). We developed a highly parameterizable load generator model that can run in gem5, sending requests at configurable rates to a server node running in the same simulation instance. However, these benchmarks also run on a real system as well. The organization of this documentation is as follows:
- Setting up real system
- Setting up gem5 for the experiments
- Running the benchmarks
  - Real System
  - gem5 simulations
    - How to run DPDK in gem5.
      - TestPMD
      - L2TouchFwd
      - L2TouchDrop
      - RxpTx
    - How to run Memcached in gem5
      - MemcachedKernel
      - MemcachedDpdk 
