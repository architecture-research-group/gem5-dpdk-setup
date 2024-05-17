#!/bin/bash 


# for j in 32 128 256 512;do
  for i in {4..17..1};do
    ./l2fwd-ckp-rxptx-ddio-disabled.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --freq 3GHz &
  done
# done



# for j in 1GHz 2GHz 3GHz;do
  for i in {20..33..1};do
    ./l2fwd-ckp-rxptx-ddio-disabled.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 3GHz &
  done
# done


# for j in 32 128 256 512;do
  for i in {40..53..1};do
    ./l2fwd-ckp-rxptx-ddio-disabled.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --freq 3GHz &
  done
# done



# for j in 3GHz;do
  for i in {40..56..1};do
    ./l2fwd-ckp-rxptx-ddio-disabled.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --freq 3GHz &
  done
# done

# wait


# for j in 1 4 8 16;do
  for i in {42..57..1};do
    ./l2fwd-ckp-rxptx-ddio-disabled.sh --num-nics 1  --script dpdk-testpmd-rxptx-1.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq 3GHz &
  done
# # done

for j in 1GHz 2GHz 4GHz;do
  for i in {1..8..1};do
    ./l2fwd-ckp-rxptx-freq-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --freq $j &
  done
done

for j in 1GHz 2GHz 4GHz;do
  for i in {1..13..1};do
    ./l2fwd-ckp-rxptx-freq-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq $j &
  done
done


for j in 1GHz 2GHz 4GHz;do
  for i in {30..58..1};do
    ./l2fwd-ckp-rxptx-freq-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq $j &
  done
done

wait