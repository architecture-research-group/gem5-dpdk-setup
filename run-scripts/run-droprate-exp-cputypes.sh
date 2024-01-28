#!/bin/bash 

# for j in 1GHz 2GHz 3GHz;do
#   for i in {1..9..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i)) --packet-size 64 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

for j in MinorCPU;do
  for i in {3..9..1};do
    ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --freq 3GHz --cpu-type $j &
  done
done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {21..25..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i)) --packet-size 64 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 32 128 256 512;do
#   for i in {13..20..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {20..28..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {24..32..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 3GHz --cpu-type $j &
#   done
# done

# wait 

# for j in 1GHz 2GHz 3GHz;do
#   for i in {33..41..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 3GHz --cpu-type $j &
#   done
# done

# wait 

# for j in 32 128 256 512;do
#   for i in {31..38..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 32 128 256 512;do
#   for i in {..60..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {51..59..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {60..68.1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 3GHz;do
#   for i in {48..65..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {57..65..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# # for j in 1GHz 2GHz 3GHz;do
# #   for i in {66..71..1};do
# #     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --freq 3GHz --cpu-type $j &
# #   done
# # done

# # wait
# # for j in 1GHz;do
# #   for i in {5..15..1};do
# #     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 3GHz --cpu-type $j &
# #   done
# # done

# # wait 


# # for j in 1GHz 2GHz;do
# #   for i in {16..23..1};do
# #     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 3GHz --cpu-type $j &
# #   done
# # done

# # wait 

# # for j in 1GHz 2GHz;do
# #   for i in 25 27 28 30;do
# #     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 3GHz --cpu-type $j &
# #   done
# # done

# # wait 

# # for j in 1GHz 2GHz;do
# #   for i in 31 32 34 40 41 42 45 53 54 55 56;do
# #     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --freq 3GHz --cpu-type $j &
# #   done
# # done

# # wait 

# for j in MinorCPU;do
#   for i in {25..45..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {54..62..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {62..70..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq 3GHz --cpu-type $j &
#   done
# done

# wait
# for j in 1GHz 2GHz 3GHz;do
#   for i in {77..87..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq 3GHz --cpu-type $j &
#   done
# done

# wait

# for j in 1GHz 2GHz 3GHz;do
#   for i in {88..100..1};do
#     ./l2fwd-ckp-cputypes.sh --num-nics 1  --script dpdk-testpmd.sh --packet-rate $((88418*$i)) --packet-size 1518 --freq 3GHz --cpu-type $j &
#   done
# done

# wait