#!/bin/bash 


for j in 16KiB 128KiB 256KiB 1MiB;do
  for i in {5..19..1};do
    ./l2fwd-ckp-l1caches.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --l1i-size=$j --l1d-size=$j --freq=3GHz &
  done
done

for j in 16KiB 128KiB 256KiB 1MiB;do
 for i in {17..35..1};do
   ./l2fwd-ckp-l1caches.sh --num-nics 1 --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --l1i-size=$j --l1d-size=$j --freq=3GHz &
 done
done


for j in 16KiB 128KiB 256KiB 1MiB;do
  for i in {38..55..1};do
    ./l2fwd-ckp-l1caches.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --l1i-size=$j --l1d-size=$j --freq=3GHz &
  done
done

wait 

for j in 16KiB 128KiB 256KiB 1MiB;do
 for i in {40..57..1};do
   ./l2fwd-ckp-l1caches.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --l1i-size=$j --l1d-size=$j --freq=3GHz &
 done
done

# # wait

for j in 16KiB 128KiB 256KiB 1MiB;do
  for i in {40..58..1};do
    ./l2fwd-ckp-l1caches.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((88418*$i)) --packet-size 1518 --l1i-size=$j --l1d-size=$j --freq=3GHz &
  done
done

for j in 1GHz 2GHz 4GHz;do
  for i in {40..58..1};do
    ./l2fwd-ckp-rxptx-freq.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq $j &
  done
done

wait
