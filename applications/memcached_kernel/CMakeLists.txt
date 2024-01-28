cmake_minimum_required (VERSION 3.16)

# Options
option(USE_DPDK_NETWORKING "Use DPDK Kernel-bypass networking" ON)
if (USE_DPDK_NETWORKING)
        message(STATUS "Building DPDK version; this will build: (1) DPDK version of the client, (2) DPDK version of memcached server.")
        message(STATUS "Make sure you have the DPDK env. installed, i.e. having the RTE_SDK and RDMA_CORE (for Mellanox NICs) variables set.")
else()
        message(STATUS "Building Kernel version; this will only build the client; use standard memcached as the server.")
endif()

# gcc setup.
add_definitions(-std=c++17 -O3 -march=native)
add_definitions(-Wall -Wextra -Wabi -Wsign-conversion -Wformat -Wformat-security)
add_definitions(-Wno-deprecated-declarations)
add_definitions(-pedantic)
add_definitions(-fstack-protector -fPIE -fPIC)
add_definitions(-Wno-unused-function)
add_definitions(-D_FORTIFY_SOURCE=2)

# Common third-party modules.
find_package(gflags REQUIRED)

#
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

SET (DPDK_LD_FLAGS "-fno-inline-atomics \
        -Wl,--whole-archive \
        -l:librte_flow_classify.a \
        -l:librte_pipeline.a \
        -l:librte_pdump.a \
        -l:librte_net_pcap.a \
        -l:librte_distributor.a \
        -l:librte_ip_frag.a \
        -l:librte_meter.a \
        -l:librte_lpm.a \
        -l:librte_acl.a \
        -l:librte_jobstats.a \
        -l:librte_metrics.a \
        -l:librte_bitratestats.a \
        -l:librte_latencystats.a \
        -l:librte_efd.a \
        -l:librte_bpf.a \
        -l:librte_cfgfile.a \
        -l:librte_gro.a \
        -l:librte_gso.a \
        -l:librte_hash.a \
        -l:librte_member.a \
        -l:librte_vhost.a \
        -l:librte_kvargs.a \
        -l:librte_mbuf.a \
        -l:librte_net.a \
        -l:librte_ethdev.a \
        -l:librte_bbdev.a \
        -l:librte_cryptodev.a \
        -l:librte_security.a \
        -l:librte_compressdev.a \
        -l:librte_eventdev.a \
        -l:librte_rawdev.a \
        -l:librte_timer.a \
        -l:librte_mempool_ring.a \
        -l:librte_mempool.a \
        -l:librte_ring.a \
        -l:librte_pci.a \
        -l:librte_eal.a \
        -l:librte_cmdline.a \
        -l:librte_reorder.a \
        -l:librte_sched.a \
        -l:librte_common_cpt.a \
        -l:librte_common_octeontx.a \
        -l:librte_common_dpaax.a \
        -l:librte_bus_pci.a \
        -l:librte_bus_vdev.a \
        -l:librte_net_e1000.a \
        -l:librte_net_tap.a \
        -l:librte_net_virtio.a \
        -l:librte_net_igc.a \
        -l:librte_common_iavf.a \
        -l:librte_kni.a \
        -l:librte_telemetry.a \
        -l:librte_rcu.a \
        -l:librte_common_mlx5.a \
        -l:librte_net_mlx5.a \
        -Wl,--no-whole-archive \
        -l:librte_table.a \
        -l:librte_port.a \
        -ldl \
        -lm \
        -latomic \
        -lmlx5 \
        -libverbs \
        -lpcap \
        -lpthread")

# Build memcached with DPDK (to run on a real system).
if (USE_DPDK_NETWORKING)
        execute_process(COMMAND ./autogen.sh
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached
                        RESULT_VARIABLE MEMCACHED_CONFIGURE_RESULT)
        if(NOT MEMCACHED_CONFIGURE_RESULT EQUAL "0")
                message(FATAL_ERROR "failed to configure memcached")
        endif()

        execute_process(COMMAND ./configure
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached
                        RESULT_VARIABLE MEMCACHED_CONFIGURE_RESULT)
        if(NOT MEMCACHED_CONFIGURE_RESULT EQUAL "0")
                message(FATAL_ERROR "failed to configure memcached")
        endif()

        add_custom_target(memcached ALL
                        /usr/bin/make -f "${CMAKE_CURRENT_SOURCE_DIR}/memcached/Makefile" CFLAGS=-fno-inline-atomics CFLAGS=-mssse3 CFLAGS+=-Wno-deprecated-declarations LDFLAGS=${DPDK_LD_FLAGS}
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached)
endif()

# Build memcached client.
if (USE_DPDK_NETWORKING)
        add_definitions("-D_USE_DPDK_CLIENT_")
        set(CMAKE_EXE_LINKER_FLAGS ${DPDK_LD_FLAGS})

        # Build our own version of 'dpdk-pdump'; we need this as due to the
        # issues of multi-processing in DPDK, both the primary process (i.e. memcached_client)
        # and the secondary one (i.e. dpdk-pdump) must be built with exactly the same libs and configs.
        # So it's better to build them together.
        add_executable(dpdk_pcap dpdk_pcap.c)
        target_compile_options(dpdk_pcap PRIVATE "-Wno-sign-conversion")
        target_link_libraries(dpdk_pcap gflags)
endif()

add_executable(memcached_client memcached_client.cc)
target_link_libraries(memcached_client gflags)
