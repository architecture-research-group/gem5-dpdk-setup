cmake_minimum_required (VERSION 3.16)

SET (DPDK_C_FLAGS CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_eal/include"
                   CFLAGS+="-I$ENV{RTE_SDK}/build"
                   CFLAGS+="-I$ENV{RTE_SDK}/config"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_eal/linux/include"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_ethdev"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_pdump"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_net"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_eal/arm/include"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_mbuf"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_mempool"
                   CFLAGS+="-I$ENV{RTE_SDK}/lib/librte_ring"
                   CFLAGS+="-D_GEM5_")

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
        LDFLAGS+="-lpthread")

# Copy memcached source code.
execute_process(COMMAND cp -r $ENV{GIT_ROOT}/applications/memcached_kernel/memcached ${CMAKE_CURRENT_SOURCE_DIR})
execute_process(COMMAND make clean WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached)
execute_process(COMMAND cp $ENV{GIT_ROOT}/applications/memcached_kernel/dpdk.h ${CMAKE_CURRENT_SOURCE_DIR})
execute_process(COMMAND cp $ENV{GIT_ROOT}/applications/memcached_kernel/helpers.h ${CMAKE_CURRENT_SOURCE_DIR})

# Call autoconf.
execute_process(COMMAND ./autogen.sh
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached
RESULT_VARIABLE MEMCACHED_CONFIGURE_RESULT)
if(NOT MEMCACHED_CONFIGURE_RESULT EQUAL "0")
message(FATAL_ERROR "failed to configure memcached.......")
endif()

execute_process(COMMAND ./configure --host=arm
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached
RESULT_VARIABLE MEMCACHED_CONFIGURE_RESULT)
if(NOT MEMCACHED_CONFIGURE_RESULT EQUAL "0")
message(FATAL_ERROR "failed to configure memcached.......")
endif()

# Build memcached with the right flags.
add_custom_target(memcached ALL
/usr/bin/make -f "${CMAKE_CURRENT_SOURCE_DIR}/memcached/Makefile" ${DPDK_C_FLAGS} ${DPDK_LD_FLAGS}
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/memcached)

# Install just built memcached into the rootfs.
install(CODE "execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/memcached/memcached $ENV{TARGET_DIR}/usr/bin/memcached_dpdk)")
