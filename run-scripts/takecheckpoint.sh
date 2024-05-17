#!/bin/bash


# Take checkpoint
# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-l2fwd.sh &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-l2fwd-touchfwd.sh &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-l2fwd-touchdrop.sh &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-512.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-256.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-3.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-touchfwd.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-touchdrop.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-1.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-10.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-50.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-100.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-30.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-70.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-300.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-500.sh --freq 3GHz &

# ./l2fwd-ckp.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd-rxptx-1000.sh --freq 3GHz &

# ./run-dual.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd.sh --drivenode-script dpdk-pktgen.sh --freq 3GHz &

# ./run-dual.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd.sh --drivenode-script dpdk-pktgen-64.sh --freq 3GHz &

# ./run-dual.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd.sh --drivenode-script dpdk-pktgen-128.sh --freq 3GHz &

# ./run-dual.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd.sh --drivenode-script dpdk-pktgen-256.sh --freq 3GHz &

# ./run-dual.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd.sh --drivenode-script dpdk-pktgen-512.sh --freq 3GHz &

# ./run-dual.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd.sh --drivenode-script dpdk-pktgen-1024.sh --freq 3GHz &

# ./run-dual.sh --take-checkpoint --num-nics 1 --script dpdk-testpmd.sh --drivenode-script dpdk-pktgen-1518.sh --freq 3GHz &

# ./run-dual-cputypes.sh --take-checkpoint --num-nics 1 --script memcached_kernel_dual.sh --drivenode-script memcached_client_kernel.sh --freq 3GHz &

# ./run-dual-cputypes.sh --take-checkpoint --num-nics 1 --script memcached_dpdk.sh --drivenode-script memcached_client_dpdk.sh --freq 3GHz &

./memcached-dpdk.sh --take-checkpoint --num-nics 1 --script memcached_dpdk.sh --l2-size 1MB --freq 3GHz &

./memcached-kernel.sh --take-checkpoint --num-nics 1 --script memcached_kernel.sh --l2-size 1MB --freq 3GHz &

