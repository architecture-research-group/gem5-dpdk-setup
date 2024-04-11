ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DPDK_BUILD=${ROOT}/dpdk/build
PKTGEN=~/gem5-dpdk-setup/Pktgen-DPDK
IF_ID=3d:00.*
echo $PKTGEN
gen_provenance(){
	mkdir -p $1

	#sys,cpu,mem
	uname -a > $1/sys_info
	(2>&1 lscpu || cat /proc/cpuinfo) > $1/cpu_info
	cat /proc/meminfo > $1/meminfo

	#kernel info
	cat /boot/config-$(uname -r) | sed -e '/#/d' -e '/^$/d' > $1/kernel_compile_params
	cat /proc/cmdline > $1/kernel_boottime_params
	2>&1 sysctl -a  > $1/kernel_runtime_params
	for mod in $( lsmod | tail -n +2 | awk '{print $1}' ); do
		ver=$(2>&1 modinfo $mod)
		printf '%s\n------------\n%s\n\n' "$mod" "$ver"
	done > kernel_module_info

	#nic info
	lspci -vvx -s $IF_ID > $1/if_pci_info.txt
	ofed_info -l > $1/mlnx_ofed_pkgs
	ofed_info -n > $1/mlnx_ofed_version_number
}

run_dpdk_app(){
	stamp=$(printf '%(%H_%M_%S_%d-%m-%Y)T')
	mkdir -p run_${stamp}
	gen_provenance run_$stamp/provenance
	echo "$@" > run_$stamp/log.txt
	2>EAL_APP.txt $@ | tee -a run_$stamp/log.txt
	chmod -R o+rwx run_$stamp
}

