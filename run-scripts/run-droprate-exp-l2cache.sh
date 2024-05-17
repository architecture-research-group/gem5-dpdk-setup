#!/bin/bash 

for j in 256kB 1MB 4MB 8MB;do
   for i in {38..55..1};do
     ./l2fwd-ckp-l2cache.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --l2-size=$j --freq=3GHz &
   done
done


for j in 256kB 1MB 4MB 8MB;do
  for i in {40..57..1};do
    ./l2fwd-ckp-l2cache.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --l2-size=$j --freq=3GHz &
  done
done

for j in 256kB 1MB 4MB 8MB;do
  for i in {40..58..1};do
    ./l2fwd-ckp-l2cache.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((88418*$i)) --packet-size 1518 --l2-size=$j --freq=3GHz &
  done
done

wait


for j in 256kB 1MB 4MB 8MB;do
    for i in {5..19..1};do
     ./l2fwd-ckp-l2cache.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --l2-size=$j --freq=3GHz &
   done
done

for j in 256kB 1MB 4MB 8MB;do
  for i in {17..35..1};do
    ./l2fwd-ckp-l2cache.sh --num-nics 1 --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --l2-size=$j --freq=3GHz &
  done
done

wait