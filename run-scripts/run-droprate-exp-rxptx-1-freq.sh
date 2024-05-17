#!/bin/bash 

# for j in 1GHz 2GHz 4GHz;do
#   for i in {1..20..1};do
#     ./l2fwd-ckp-rxptx-freq.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --freq $j &
#   done
# done


for j in 1GHz 2GHz 4GHz;do
  for i in {15..35..1};do
    ./l2fwd-ckp-rxptx-freq.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq $j &
  done
done

# wait 

for j in 1GHz 2GHz 4GHz;do
  for i in {35..57..1};do
    ./l2fwd-ckp-rxptx-freq.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --freq $j &
  done
done


for j in 1GHz 2GHz 4GHz;do
  for i in {35..57..1};do
    ./l2fwd-ckp-rxptx-freq.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --freq $j &
  done
done

wait

# for j in 1GHz 2GHz 4GHz;do
#   for i in {40..58..1};do
#     ./l2fwd-ckp-rxptx-freq.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq $j &
#   done
# done
