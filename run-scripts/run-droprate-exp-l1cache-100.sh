#!/bin/bash 

# ##for j in 1GHz 2GHz 3GHz;do
  ###for i in 4 5 6 9 11 13 15 16 18;do
    #./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i)) --packet-size 64 & #&
  ###done
# ##done

# # wait

#for j in 16KiB 128KiB 256KiB 1MiB;do
#   for i in {1..5..1};do
#     ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i)) --packet-size 64 --l1i-size=$j --l1d-size=$j --freq=3GHz &
#   done
#done

# # wait

for j in 16KiB 128KiB 256KiB 1MiB;do
  for i in {1..10..1};do
    ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/2)) --packet-size 128 --l1i-size=$j --l1d-size=$j --freq=3GHz &
  done
done

# # wait

# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {21..30..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/2)) --packet-size 128 & #&
  # ##done
# ##done
# sleep 5
# # wait

# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {31..40..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/2)) --packet-size 128 & #&
  # ##done
# ##done

# # wait

for j in 16KiB 128KiB 256KiB 1MiB;do
 for i in {1..13..1};do
   ./l2fwd-ckp-l1caches-100.sh --num-nics 1 --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/4)) --packet-size 256 --l1i-size=$j --l1d-size=$j --freq=3GHz &
 done
done

## wait 
# sleep 5
# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {31..40..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/4)) --packet-size 256 & #&
  # ##done
# ##done

# wait 

for j in 16KiB 128KiB 256KiB 1MiB;do
  for i in {1..22..1};do
    ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/8)) --packet-size 512 --l1i-size=$j --l1d-size=$j --freq=3GHz &
  done
done

## wait

# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {41..50..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/8)) --packet-size 512 & #&
  # ##done
# ##done
# sleep 5
# # wait

# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {51..60..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/8)) --packet-size 512 & #&
  # ##done
# ##done

# # wait

for j in 16KiB 128KiB 256KiB 1MiB;do
 for i in {15..45..1};do
   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 --l1i-size=$j --l1d-size=$j --freq=3GHz &
 done
done

## wait
# sleep 5
# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {79..100..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((2150786*$i/16)) --packet-size 1024 & #&
  # ##done
# ##done

# # wait

for j in 16KiB 128KiB 256KiB 1MiB;do
  for i in {20..58..1};do
    ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((88418*$i)) --packet-size 1518 --l1i-size=$j --l1d-size=$j --freq=3GHz &
  done
done

# # wait

# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {69..100..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((88418*$i)) --packet-size 1518 & #&
  # ##done
# ##done

# # wait

# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {81..90..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((88418*$i)) --packet-size 1518 & #&
  # ##done
# ##done

# # wait

# ##for j in 1GHz 2GHz 3GHz;do
  # ##for i in {91..100..1};do
  #   ./l2fwd-ckp-l1caches-100.sh --num-nics 1  --script dpdk-testpmd-rxptx-100.sh --packet-rate $((88418*$i)) --packet-size 1518 & #&
  # ##done
# ##done

wait
