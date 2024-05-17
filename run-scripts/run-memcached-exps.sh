#!/bin/bash 

## list of packet rates to test
rates=(230000 240000)
start_rate=100000
stop_rate=300000
##l2 sizes
l1_sizes=(16KiB 128KiB 256KiB 1MiB)
l2_sizes=(256kB 1MB 4MB 8MB)
l3_sizes=(4MB 16MB 32MB 64MB)
mem_channel=(1 4 8 16)
rob_entries=(32 128 256 512)
cpu_types=(MinorCPU) #
## frequencies
freq=(1GHz 2GHz)

## loop over all packet rates
# for rate in "${rates[@]}"; do
for ((rate=start_rate; rate <= stop_rate; rate+=10000)); do
    ## loop over all frequencies
    for CH in "${mem_channel[@]}"; do
      ## run the experiment
      ./memcached-kernel-caches.sh --num-nics 1 --script memcached_kernel.sh --packet-rate $rate --freq 3GHz  --l1-size 64KiB --l2-size 1MB --l3-size 16MB --mem-channels $CH &
  done
done
# wait
# loop over all packet rates and then l2 sizes
# for rate in "${rates[@]}"; do
#     for l2 in "${l2_sizes[@]}"; do
#       ./memcached-kernel.sh --num-nics 1 --script memcached_kernel.sh --packet-rate $rate --l2-size $l2 --freq 3GHz &
#   done
# done

# wait