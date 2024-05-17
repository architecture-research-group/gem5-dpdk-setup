#!/bin/bash
source ../../shared.sh

set -e

prompt_for_password() {
	read -sp "Enter your password: " password
}

PMD=$DPDK_BUILD/app/dpdk-testpmd
REMOTE_SERVER=sapphire # Enter remote server 'username@ip_address' to run pktgen application
LOGICAL=80-81
HUGEMEM=1024 #1GB hugepage memory
PORTS=0x0001
OUTDIR=stats_rxptx

mkdir -p $OUTDIR

password= # or Enter your password here
prompt_for_password # uncomment this line to prompt for password
K=$password

dur=$( bc -l <<< "12 + 1.5 * $3")
t=30000

eval `ssh-agent`
ssh-add

for i in 1; do # Repeat n times
while read -u3 a b c; do 
	for j in 1 100 1000; do 
		echo "====== Running $a-$b-$c-$j configuration for the $i-th iteration now ======"
		sudo cpupower -c $LOGICAL frequency-set -f 3000000
		
	./cfg_gen.sh $a $b $c > "cfgs/${a}_${b}_${c}.pkt"
	dur=$( bc -l <<< "12 + 1.5 * $c")
	t=27000

	#ssh -n -tt $REMOTE_SERVER "cd ~/gem5-dpdk-setup/dpdk-pktgen-build/exp/pktgen/ && echo $K | sudo -S $PKTGEN/usr/local/bin/pktgen -l 0-3 -n 4 -- -P -m "[1-$j:17-$((16+$j))].0" -f "cfgs/${a}_${b}_${c}.pkt""  > /dev/null &
	
	ssh -n -tt $REMOTE_SERVER "cd ~/gem5-dpdk-setup/dpdk-pktgen-build/exp/pktgen/ && echo $K | sudo -S $PKTGEN/usr/local/bin/pktgen -l 1-3 -n 4 -a 3d:00.0 -- -P -m "[2:3].0" -f "cfgs/${a}_${b}_${c}.pkt"" > /dev/null &
	
	#sudo perf stat -e l1i_cache,L1-icache-load-misses,l1d_cache_rd,l1d_cache_wr,L1-dcache-load-misses,l2d_cache_rd,l2d_cache_wr,l3d_cache,l3d_cache_rd,mem_access,l1d_tlb,l2d_tlb,stall_backend,stall_frontend,cpu_cycles,instructions -o "micro_uarch/${a}_${b}_${c}_${j}_${i}.txt" -C 81 timeout --foreground $dur $PMD -l $LOGICAL -n 4 -- --portmask=$PORTS --nb-cores=1 --forward-mode=macswap --txd=1024 --rxd=1024 > /dev/null #| grep -E "RX-packets: [0-9]* | TX-packets: [0-9]*" >> "stats-rxptx/${a}_${b}_${c}_${j}.txt" &
	sudo timeout --foreground $dur $PMD -l $LOGICAL -n 4 -- --portmask=$PORTS --nb-cores=1 --forward-mode=macswap --forward-mode=rxptx --txd=1024 --rxd=1024 --proc_times=$j | grep -E "RX-packets: [0-9]* | TX-packets: [0-9]*" >> "$OUTDIR/${a}_${b}_${c}_${j}.txt" 

	echo "done"

done 
done 3< configs-test.txt

done

