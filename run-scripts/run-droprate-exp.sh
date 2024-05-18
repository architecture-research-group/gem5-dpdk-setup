#!/bin/bash 


# for j in 1 4 8 16;do
  for i in {1..15..1};do
    ./l2fwd-ckp.sh --num-nics 1  --script dpdk-testpmd-touchfwd.sh --packet-rate $((2150786*$i)) --packet-size 64 --freq 4GHz &
  done
# done



# for j in 32 128 256 512;do
  for i in {10..20..1};do
    ./l2fwd-ckp.sh --num-nics 1  --script dpdk-testpmd-touchfwd.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --freq 4GHz &
  done
# done

# wait

# for j in 1GHz 2GHz 4GHz;do
  for i in {20..35..1};do
    ./l2fwd-ckp.sh --num-nics 1  --script dpdk-testpmd-touchfwd.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 4GHz &
  done
# done

# wait

# for j in 32 128 256 512;do
  for i in {45..56..1};do
    ./l2fwd-ckp.sh --num-nics 1  --script dpdk-testpmd-touchfwd.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --freq 4GHz &
  done
# done


# for j in 4GHz;do
  for i in {50..57..1};do
    ./l2fwd-ckp.sh --num-nics 1  --script dpdk-testpmd-touchfwd.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --freq 4GHz &
  done
# done

# # wait 

# for j in 1 4 8 16;do
  for i in {52..60..1};do
    ./l2fwd-ckp.sh --num-nics 1  --script dpdk-testpmd-touchfwd.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq 4GHz &
  done
# done

wait