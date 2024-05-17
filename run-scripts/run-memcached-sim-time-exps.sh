#!/bin/bash 

# for j in 1GHz 2GHz 3GHz 4GHz;do
#   for i in iperf-64.sh iperf-128.sh iperf-256.sh iperf-512.sh iperf-1024.sh iperf-1518.sh;do
#     ./run-dual-freq.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq $j &
#   done
# done

# # wait

# for j in 16KiB 128KiB 256KiB 1024KiB;do
#   for i in iperf-64.sh iperf-128.sh iperf-256.sh iperf-512.sh iperf-1024.sh iperf-1518.sh;do
#     ./run-dual-l1cache.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq 3GHz --l1i-size $j --l1d-size $j &
#   done
# done

# # wait

# for j in 256KiB 1024KiB 4096KiB 8192KiB;do
#   for i in iperf-64.sh iperf-128.sh iperf-256.sh iperf-512.sh iperf-1024.sh iperf-1518.sh;do
#     ./run-dual-l2cache.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq 3GHz --l2-size $j &
#   done
# done

# # wait 

# for j in 4MiB 16MiB 32MiB 64MiB;do
#   for i in iperf-64.sh iperf-128.sh iperf-256.sh iperf-512.sh iperf-1024.sh iperf-1518.sh;do
#     ./run-dual-l3cache.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq 3GHz --l3-size $j &
#   done
# done


# # for j in 1GHz 2GHz 3GHz 4GHz;do
#   for i in iperf-64.sh iperf-128.sh iperf-256.sh iperf-512.sh iperf-1024.sh iperf-1518.sh;do
#     ./run-dual-ddio-disabled.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq 3GHz &
#   done
# # done


# # wait

# for j in LTAGE LocalBP MultiperspectivePerceptron64KB TournamentBP;do
#   for i in iperf-64.sh iperf-1518.sh;do
#     ./run-dual-branchpred.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq 3GHz --branch-pred $j &
#   done
# done

# # wait

# for j in 256 4096 16384 32768;do
#   for i in iperf-64.sh iperf-1518.sh;do
#     ./run-dual-btbentries.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq 3GHz --btb-entries $j &
#   done
# done

# # wait

for k in MinorCPU;do
for j in 1GHz 2GHz 3GHz 4GHz;do
  for i in memcached_client_dpdk.sh;do
    ./run-dual-cputypes.sh --num-nics 1  --script memcached_dpdk.sh --drivenode-script $i --freq $j --cpu-types $k &
  done
done
done


# wait

# for j in 1 4 8 16;do
#   for i in iperf-64.sh iperf-1518.sh;do
#     ./run-dual-memchannel.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq 3GHz --mem-channel $j &
#   done
# done

# for j in 32 128 256 512;do
#   for i in iperf-64.sh iperf-1518.sh;do
#     ./run-dual-robentries.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq 3GHz --rob-entries $j &
#   done
# done

# for j in 1GHz 2GHz 3GHz 4GHz;do
#   for i in iperf-128-testnode.sh iperf-256-testnode.sh iperf-512-testnode.sh iperf-1024-testnode.sh iperf-1518-testnode.sh;do
#     ./run-dual-freq.sh --num-nics 1  --script iperf-1.sh --drivenode-script $i --freq $j &
#   done
# done

# for j in 1GHz 2GHz 3GHz 4GHz;do
  # for j in 1GHz 2GHz 3GHz 4GHz;do
  #   ./run-loadgen.sh --num-nics 1  --script iperf-testnode.sh --pcap-filename iperf3_128pkt.pcap --packet-rate 1523 --freq $j &
  #   ./run-loadgen.sh --num-nics 1  --script iperf-testnode.sh --pcap-filename iperf3_256pkt.pcap --packet-rate 612 --freq $j &
  #   ./run-loadgen.sh --num-nics 1  --script iperf-testnode.sh --pcap-filename iperf3_512pkt.pcap --packet-rate 279 --freq $j &
  #   ./run-loadgen.sh --num-nics 1  --script iperf-testnode.sh --pcap-filename iperf3_1024pkt.pcap --packet-rate 134 --freq $j &
  #   ./run-loadgen.sh --num-nics 1  --script iperf-testnode.sh --pcap-filename iperf3_1518pkt.pcap --packet-rate 89 --freq $j &
  # done
# done

wait
