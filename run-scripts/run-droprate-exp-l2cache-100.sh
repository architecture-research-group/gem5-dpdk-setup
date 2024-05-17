#!/bin/bash 

for j in 256kB 1MB 4MB 8MB;do
    for i in {1..10..1};do
     ./l2fwd-ckp-l2cache-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --l2-size=$j --freq=3GHz &
   done
done


for j in 256kB 1MB 4MB 8MB;do
  for i in {1..13..1};do
    ./l2fwd-ckp-l2cache-100.sh --num-nics 1 --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --l2-size=$j --freq=3GHz &
  done
done

for j in 256kB 1MB 4MB 8MB;do
  for i in {15..45..1};do
    ./l2fwd-ckp-l2cache-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --l2-size=$j --freq=3GHz &
  done
done

wait 

for j in 256kB 1MB 4MB 8MB;do
   for i in {1..22..1};do
     ./l2fwd-ckp-l2cache-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --l2-size=$j --freq=3GHz &
   done
done

for j in 256kB 1MB 4MB 8MB;do
  for i in {20..58..1};do
    ./l2fwd-ckp-l2cache-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((88418*$i)) --packet-size 1518 --l2-size=$j --freq=3GHz &
  done
done

wait
