#!/bin/bash 

## list of packet rates to test
rates=(400000 410000 420000 430000 440000 450000 460000 470000 480000 490000 500000 510000 520000 530000 540000 550000 560000 570000 580000)
start_rate=600000
stop_rate=800000
##l2 sizes
l1_sizes=(16KiB 128KiB 256KiB 1MiB)
l2_sizes=(256kB 1MB 4MB 8MB)
l3_sizes=(4MB 16MB 32MB 64MB)
mem_channel=(1 4 8 16)
rob_entries=(32 128 256 512)
cpu_types=(MinorCPU) #
## frequencies
freq=(1GHz)

## loop over all packet rates
# for rate in "${rates[@]}"; do
for ((rate=start_rate; rate <= stop_rate; rate+=10000)); do
    ## loop over all frequencies
    for CH in "${mem_channel[@]}"; do
      ## run the experiment
      ./memcached-dpdk-caches.sh --num-nics 1 --script memcached_dpdk.sh --packet-rate $rate --freq 3GHz --l1-size 64KiB --l2-size 1MB --l3-size 16MB --mem-channels $CH &
    done
done
# wait
# ## loop over all packet rates and then l2 sizes
# for rate in "${rates[@]}"; do
#     for l2 in "${l2_sizes[@]}"; do
#       ./memcached-dpdk.sh --num-nics 1 --script memcached_dpdk.sh --packet-rate $rate --l2-size $l2 --freq 3GHz &
#   done
# done
sleep 540
# wait