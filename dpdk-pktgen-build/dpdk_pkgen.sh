#!/bin/bash
#set -e
source ./shared.sh

DPDK_VER=20.11.3
PKT_VER=20.11.3

install_dpdk() {
	rm -rf dpdk
	mkdir dpdk

	wget http://fast.dpdk.org/rel/dpdk-$DPDK_VER.tar.xz
	tar -xf dpdk-$DPDK_VER.tar.xz -C dpdk --strip-components=1
	rm -rf dpdk-$DPDK_VER.tar.xz*
	
	touch dpdk/app/test-pmd/rxptx.c dpdk/app/test-pmd/touchfwd.c
	patch -p1 < dpdk_v$DPDK_VER.patch

	cd ./dpdk
	meson setup build #-Dplatform=native -Denable_drivers=mlx5_core,qat -Dexamples=all build
	cd build
	ninja
	sudo ninja install

	#cd ${ROOT}
}

install_pktgen() {
	rm -rf $PKTGEN
	mkdir $PKTGEN

	wget https://git.dpdk.org/apps/pktgen-dpdk/snapshot/pktgen-dpdk-pktgen-$PKT_VER.tar.gz --no-check-certificate
	tar -xf pktgen-dpdk-pktgen-$PKT_VER.tar.gz -C $PKTGEN --strip-components=1
	rm -rf pktgen-dpdk-pktgen-$PKT_VER.tar.gz*

	cd $PKTGEN

	export RTE_SDK=${ROOT}/dpdk
	export RTE_TARGET=x86_64_native_linux_gcc
	export PKTGEN_DIR=$PKTGEN
	export PKG_CONFIG_PATH=/scratch/pding/opt/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH

	make -j
	cd ..
}

clean_dpdk() {
	rm -rf dpdk
}
clean_pktgen() {
	rm -rf $PKTGEN
}
#for arg in "$@"; do 
#	case $arg
