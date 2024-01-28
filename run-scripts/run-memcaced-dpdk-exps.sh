#!/bin/bash 

## list of packet rates to test
rates=(10000 20000 40000 80000)
##l2 sizes
l2_sizes=(256kB 512kB 4MB 8MB)
## frequencies
freq=(1GHz 2GHz 3GHz 4GHz)

## loop over all packet rates
for rate in "${rates[@]}"; do
    ## loop over all frequencies
    for f in "${freq[@]}"; do
      ## run the experiment
      ./memcached-dpdk.sh --num-nics 1 --script memcached_dpdk.sh --packet-rate $rate --l2-size 1MB --freq $f &
  done
done
wait
## loop over all packet rates and then l2 sizes
for rate in "${rates[@]}"; do
    for l2 in "${l2_sizes[@]}"; do
      ./memcached-dpdk.sh --num-nics 1 --script memcached_dpdk.sh --packet-rate $rate --l2-size $l2 --freq 3GHz &
  done
done

wait
