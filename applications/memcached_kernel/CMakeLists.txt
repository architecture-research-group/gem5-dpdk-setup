cmake_minimum_required (VERSION 3.16)

option(USE_DPDK_NETWORKING "Use DPDK Kernel-bypass Networking" ON)
if (USE_DPDK_NETWORKING)	 
 	message(STATUS "Building DPDK version; this will build: (1) DPDK version of the client, (2) DPDK version of memcached server.")
        message(STATUS "Make sure you have the DPDK env. installed, i.e. having the RTE_SDK and RDMA_CORE (for Mellanox NICs) variables set.")
else()
        message(STATUS "Building Kernel version; this will only build the client; use standard memcached as the server.")
endif()

SET (DPDK_C_FLAGS CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_eal/include"
                   CFLAGS+="-I$ENV{RTE_SDK}/build"
                   CFLAGS+="-I$ENV{RTE_SDK}/config"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_eal/linux/include"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_ethdev"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_pdump"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_net"
		   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_eal/x86/include" #change x86 to arm, if using ARM
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_mbuf"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_mempool"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_ring"
		   # CFLAGS+="-D_GEM5_") # Only needed when adding these packages to the buildroot disk image for gem5 simulations
		   CFLAGS+="-mssse3")

SET (DPDK_LD_FLAGS LDFLAGS+="-L$ENV{RTE_SDK}/build/drivers"
        LDFLAGS+="-L$ENV{RTE_SDK}/build/lib"
        LDFLAGS+="-fno-inline-atomics"
        LDFLAGS+="-Wl,--whole-archive"
        LDFLAGS+="-l:librte_flow_classify.a"
        LDFLAGS+="-l:librte_pipeline.a"
        LDFLAGS+="-l:librte_pdump.a"
        LDFLAGS+="-l:librte_distributor.a"
        LDFLAGS+="-l:librte_ip_frag.a"
        LDFLAGS+="-l:librte_meter.a"
        LDFLAGS+="-l:librte_lpm.a"
        LDFLAGS+="-l:librte_acl.a"
        LDFLAGS+="-l:librte_jobstats.a"
        LDFLAGS+="-l:librte_metrics.a"
        LDFLAGS+="-l:librte_bitratestats.a"
        LDFLAGS+="-l:librte_latencystats.a"
        LDFLAGS+="-l:librte_efd.a"
        LDFLAGS+="-l:librte_bpf.a"
        LDFLAGS+="-l:librte_cfgfile.a"
        LDFLAGS+="-l:librte_gro.a"
        LDFLAGS+="-l:librte_gso.a"
        LDFLAGS+="-l:librte_hash.a"
        LDFLAGS+="-l:librte_member.a"
        LDFLAGS+="-l:librte_vhost.a"
        LDFLAGS+="-l:librte_kvargs.a"
        LDFLAGS+="-l:librte_mbuf.a"
        LDFLAGS+="-l:librte_net.a"
        LDFLAGS+="-l:librte_ethdev.a"
        LDFLAGS+="-l:librte_bbdev.a"
        LDFLAGS+="-l:librte_cryptodev.a"
        LDFLAGS+="-l:librte_security.a"
        LDFLAGS+="-l:librte_compressdev.a"
        LDFLAGS+="-l:librte_eventdev.a"
        LDFLAGS+="-l:librte_rawdev.a"
        LDFLAGS+="-l:librte_timer.a"
        LDFLAGS+="-l:librte_mempool_ring.a"
        LDFLAGS+="-l:librte_mempool.a"
        LDFLAGS+="-l:librte_ring.a"
        LDFLAGS+="-l:librte_pci.a"
        LDFLAGS+="-l:librte_eal.a"
        LDFLAGS+="-l:librte_cmdline.a"
        LDFLAGS+="-l:librte_reorder.a"
        LDFLAGS+="-l:librte_sched.a"
        LDFLAGS+="-l:librte_common_cpt.a"
        LDFLAGS+="-l:librte_common_octeontx.a"
        LDFLAGS+="-l:librte_common_dpaax.a"
        LDFLAGS+="-l:librte_bus_pci.a"
        LDFLAGS+="-l:librte_bus_vdev.a"
        LDFLAGS+="-l:librte_net_e1000.a"
        LDFLAGS+="-l:librte_net_tap.a"
        LDFLAGS+="-l:librte_net_virtio.a"
        LDFLAGS+="-l:librte_net_igc.a"
        LDFLAGS+="-l:librte_common_iavf.a"
        LDFLAGS+="-l:librte_kni.a"
        LDFLAGS+="-l:librte_telemetry.a"
        LDFLAGS+="-l:librte_rcu.a"
        LDFLAGS+="-Wl,--no-whole-archive"
        LDFLAGS+="-l:librte_table.a"
        LDFLAGS+="-l:librte_port.a"
        LDFLAGS+="-ldl"
        LDFLAGS+="-lm"
        LDFLAGS+="-latomic"
        LDFLAGS+="-lpthread"
        LDFLAGS+="-lelf"
        LDFLAGS+="-lnuma"
        LDFLAGS+="-lbsd")

if(USE_DPDK_NETWORKING)
	# Call autoconf.
	execute_process(COMMAND ./autogen.sh
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached
		RESULT_VARIABLE MEMCACHED_CONFIGURE_RESULT)
	if(NOT MEMCACHED_CONFIGURE_RESULT EQUAL "0")
		message(FATAL_ERROR "failed to configure memcached.......")
	endif()

	execute_process(COMMAND ./configure --host=x86 #change to --host=arm if using ARM platform
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached
		RESULT_VARIABLE MEMCACHED_CONFIGURE_RESULT)
	if(NOT MEMCACHED_CONFIGURE_RESULT EQUAL "0")
		message(FATAL_ERROR "failed to configure memcached.......")
	endif()

	# Build memcached with the right flags.
	add_custom_target(memcached ALL
		/usr/bin/make -f "${CMAKE_CURRENT_SOURCE_DIR}/memcached/Makefile" ${DPDK_LD_FLAGS} ${DPDK_C_FLAGS}
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached)
	# Install just built memcached  into the rootfs.
	#install(CODE "execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/memcached/memcached $ENV{TARGET_DIR}/usr/bin/memcached_dpdk)")
endif()

# common requirements
find_package(gflags REQUIRED)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
#include_directories(${CMAKE_CURRENT_SOURCE_DIR}/gem5-include)
# link_directories(${CMAKE_CURRENT_SOURCE_DIR}/gem5-lib)
# link_libraries(m5 gflags)
link_libraries(gflags)
#add_definitions("-D_GEM5_") # Only needed when adding these packages to the buildroot disk image for gem5 simulations

if(USE_DPDK_NETWORKING)
	include_directories($ENV{RTE_SDK}/config)
	include_directories($ENV{RTE_SDK}/build)
	include_directories($ENV{RTE_SDK}/lib/librte_eal/include)
	include_directories($ENV{RTE_SDK}/lib/librte_eal/linux/include)
	include_directories($ENV{RTE_SDK}/lib/librte_ethdev)
	include_directories($ENV{RTE_SDK}/lib/librte_net)
	include_directories($ENV{RTE_SDK}/lib/librte_eal/x86/include) #change x86 to arm, if using ARM
	include_directories($ENV{RTE_SDK}/lib/librte_mbuf)
	include_directories($ENV{RTE_SDK}/lib/librte_mempool)
	include_directories($ENV{RTE_SDK}/lib/librte_ring)
	include_directories($ENV{RTE_SDK}/lib/librte_pdump)
	include_directories($ENV{RTE_SDK}/lib/librte_kvargs)
	add_definitions("-D_USE_DPDK_CLIENT_")
	#add_definitions(-std=c++17 -O3) # without this, you get an assembler error message Error on ARM Neoverse CPU: selected processor does not support `casp x0,x1,x2,x3,[x4]'
	# link_libraries must come before add_executable
	link_libraries(
        -L$ENV{RTE_SDK}/build/drivers
        -L$ENV{RTE_SDK}/build/lib
        -fno-inline-atomics
        -Wl,--whole-archive
        -l:librte_flow_classify.a
        -l:librte_pipeline.a
        -l:librte_pdump.a
        -l:librte_distributor.a
        -l:librte_ip_frag.a
        -l:librte_meter.a
        -l:librte_lpm.a
        -l:librte_acl.a
        -l:librte_jobstats.a
        -l:librte_metrics.a
        -l:librte_bitratestats.a
        -l:librte_latencystats.a
        -l:librte_efd.a
        -l:librte_bpf.a
        -l:librte_cfgfile.a
        -l:librte_gro.a
        -l:librte_gso.a
        -l:librte_hash.a
        -l:librte_member.a
        -l:librte_vhost.a
        -l:librte_kvargs.a
        -l:librte_mbuf.a
        -l:librte_net.a
        -l:librte_ethdev.a
        -l:librte_bbdev.a
        -l:librte_cryptodev.a
        -l:librte_security.a
        -l:librte_compressdev.a
        -l:librte_eventdev.a
        -l:librte_rawdev.a
        -l:librte_timer.a
        -l:librte_mempool_ring.a
        -l:librte_mempool.a
        -l:librte_ring.a
        -l:librte_pci.a
        -l:librte_eal.a
        -l:librte_cmdline.a
        -l:librte_reorder.a
        -l:librte_sched.a
        -l:librte_common_cpt.a
        -l:librte_common_octeontx.a
        -l:librte_common_dpaax.a
        -l:librte_bus_pci.a
        -l:librte_bus_vdev.a
        -l:librte_net_e1000.a
        -l:librte_net_tap.a
        -l:librte_net_virtio.a
        -l:librte_net_igc.a
        -l:librte_common_iavf.a
        -l:librte_kni.a
        -l:librte_telemetry.a
        -l:librte_rcu.a
        -Wl,--no-whole-archive
        -l:librte_table.a
        -l:librte_port.a
        -ldl
        -lm
        -latomic
        -lpthread
        -lnuma
        -lbsd
        -lelf)

	# Build memcached dpdk client with the right flags and install into rootfs.
	add_executable(memcached_client_dpdk memcached_client.cc)	
	target_compile_options(memcached_client_dpdk PRIVATE "-mssse3") # comment out this line if using ARM platforms
	#target_link_libraries(memcached_client_dpdk gflags)
	#install(CODE "execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/memcached_client_dpdk $ENV{TARGET_DIR}/usr/bin/memcached_client_dpdk)")

	# Build dpdk_pcap with the right flags and install into rootfs.
	#set(CMAKE_EXE_LINKER_FLAGS ${DPDK_LD_FLAGS})
	add_executable(dpdk_pcap dpdk_pcap.c)
	target_compile_options(dpdk_pcap PRIVATE "-Wno-sign-conversion" "-mssse3") # remove "-mssse3" compiler option if using ARM
	#target_link_libraries(dpdk_pcap gflags)
	#install(CODE "execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/dpdk_pcap $ENV{TARGET_DIR}/usr/bin/dpdk_pcap)")
else()
	#gcc setup
	add_definitions(-std=c++17 -O3 -march=native)
	add_definitions(-Wall -Wextra -Wabi -Wsign-conversion -Wno-sign-compare -Wformat -Wformat-security)
	add_definitions(-Wno-deprecated-declarations)
	add_definitions(-pedantic)
	add_definitions(-fstack-protector -fPIE -fPIC)
	add_definitions(-Wno-unused-function)
	add_definitions(-D_FORTIFY_SOURCE=2)

	# Build memcached kernel client with the right flags and install into rootfs.
	#set(CMAKE_EXE_LINKER_FLAGS ${MC_LD_FLAGS})
	add_executable(memcached_client_kernel memcached_client.cc)
	# Set the directory containing the gem5-lib library
	#target_link_directories(memcached_client_kernel PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/gem5-lib)

	# Link against the gem5-lib library (static)
	#target_link_libraries(memcached_client_kernel PRIVATE m5 gflags)

	#target_link_libraries(memcached_client_kernel gflags)
	#install(CODE "execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/memcached_client_kernel $ENV{TARGET_DIR}/usr/bin/memcached_client_kernel)")
endif()
