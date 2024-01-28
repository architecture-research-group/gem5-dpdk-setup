# Copyright (c) 2012-2013, 2015-2016 ARM Limited
# Copyright (c) 2020 Barkhausen Institut
# All rights reserved
#
# The license below extends only to copyright in the software and shall
# not be construed as granting a license to any other intellectual
# property including but not limited to intellectual property relating
# to a hardware implementation of the functionality of the software
# licensed hereunder.  You may use the software subject to the license
# terms below provided that you ensure that this notice is replicated
# unmodified and in its entirety in all distributions of the software,
# modified or unmodified, in source code or in binary form.
#
# Copyright (c) 2010 Advanced Micro Devices, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met: redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer;
# redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution;
# neither the name of the copyright holders nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Configure the M5 cache hierarchy config in one place
#

import m5
from m5.objects import *
from common.Caches import *
from common import ObjectList

class L1CacheSmt(Cache):
    """ This is a Simple L1Cache That Models a Cache with 4 ports:
        2 iCache ports and 2 dCache ports """
    assoc = 2
    tag_latency = 2
    data_latency = 2
    response_latency = 2
    mshrs = 4
    tgts_per_mshr = 20
    
    # def __init__(self):
    #     super(L1CacheSmt, self).__init__()
    #     pass

    def connectBus(self, bus):
        """Connect this cache to a memory-side bus"""
        self.mem_side = bus.cpu_side_ports # or self.mem_side = bus.slave

    def connectCPU(self, cpu):
        """Connect this cache's port to a CPU-side port
           This must be defined in a subclass"""
        raise NotImplementedError
    
class L1ICacheSmt(L1CacheSmt):
    """Simple L1I Cache with default values"""
    # def __init__(self):
    #     super(L1ICacheSmt,self).__init__()
    #     pass
     
    def connectCPU(self, cpu):
        """Connect this cache's port to a CPU-side port
           This must be defined in a subclass"""
        self.cpu_side = cpu.icache_port

class L1DCacheSmt(L1CacheSmt):
    """Simple L1D Cache with default values"""
     
    # def __init__(self):
    #     super(L1DCacheSmt,self).__init__()
    #     pass

    def connectCPU(self, cpu):
        """Connect this cache's port to a CPU-side port
           This must be defined in a subclass"""
        self.cpu_side = cpu.dcache_port

class L2CacheSmt(Cache):
    """Simple L2 Cache with default values"""
    assoc = 8
    tag_latency = 20
    data_latency = 20
    response_latency = 20
    mshrs = 20
    tgts_per_mshr = 12
    write_buffers = 8
    # def __init__(self):
    #     super(L2CacheSmt,self).__init__()
    #     pass

    def connectCPUSideBus(self, bus):
        """Connect this cache's port to a CPU-side port
           This must be defined in a subclass"""
        raise NotImplementedError

    def connectMemSideBus(self, bus):
        """Connect this cache's port to a CPU-side port
           This must be defined in a subclass"""
        self.mem_side = bus.cpu_side_ports # or self.mem_side = bus.slave

class L2CacheSmtCpu(L2CacheSmt):
    """Simple L2 Cache with default values"""
    # def __init__(self):
    #     super(L2CacheSmtCpu,self).__init__()
    #     pass

    def connectCPUSideBus(self, bus):
        """Connect this cache's port to a CPU-side port
           This must be defined in a subclass"""
        self.cpu_side = bus.mem_side_ports # or self.cpu_side = bus.master

class L3CacheSmt(Cache):
    """Simple L3 Cache with default values"""
    assoc = 8
    tag_latency = 20
    data_latency = 20
    response_latency = 20
    mshrs = 20
    tgts_per_mshr = 12
    write_buffers = 8
    # def __init__(self):
    #     super(L3CacheSmt,self).__init__()
    #     pass

    def connectCPUSideBus(self, bus):
        """Connect this cache's port to a CPU-side port
           This must be defined in a subclass"""
        self.cpu_side = bus.mem_side_ports # or self.cpu_side = bus.master

    def connectMemSideBus(self, bus):
        """Connect this cache's port to a CPU-side port
           This must be defined in a subclass"""
        self.mem_side = bus.cpu_side_ports # or self.cpu_side = bus.slave

def _get_hwp(hwp_option):
    if hwp_option == None:
        return NULL

    hwpClass = ObjectList.hwp_list.get(hwp_option)
    return hwpClass()

def _get_cache_opts(level, options):
    opts = {}

    size_attr = '{}_size'.format(level)
    if hasattr(options, size_attr):
        opts['size'] = getattr(options, size_attr)

    assoc_attr = '{}_assoc'.format(level)
    if hasattr(options, assoc_attr):
        opts['assoc'] = getattr(options, assoc_attr)

    prefetcher_attr = '{}_hwp_type'.format(level)
    if hasattr(options, prefetcher_attr):
        opts['prefetcher'] = _get_hwp(getattr(options, prefetcher_attr))

    return opts

def config_cache(options, system):
    if options.external_memory_system and (options.caches or options.l2cache):
        print("External caches and internal caches are exclusive options.\n")
        sys.exit(1)
    
    if (options.smt_model or options.smt) and options.num_cpus%2 != 0:
        print("You can only use the SMT models with even number of cores.\n")
        sys.exit(1)

    if options.external_memory_system:
        ExternalCache = ExternalCacheFactory(options.external_memory_system)

    if options.cpu_type == "O3_ARM_v7a_3":
        try:
            import cores.arm.O3_ARM_v7a as core
        except:
            print("O3_ARM_v7a_3 is unavailable. Did you compile the O3 model?")
            sys.exit(1)

        dcache_class, icache_class, l2_cache_class, walk_cache_class = \
            core.O3_ARM_v7a_DCache, core.O3_ARM_v7a_ICache, \
            core.O3_ARM_v7aL2, \
            core.O3_ARM_v7aWalkCache
    elif options.cpu_type == "HPI":
        try:
            import cores.arm.HPI as core
        except:
            print("HPI is unavailable.")
            sys.exit(1)

        dcache_class, icache_class, l2_cache_class, walk_cache_class = \
            core.HPI_DCache, core.HPI_ICache, core.HPI_L2, core.HPI_WalkCache
    elif options.smt:
        dcache_class, icache_class, dcache_class_smt, icache_class_smt, l2_cache_class, walk_cache_class = \
            L1_DCache, L1_ICache, L1_DCache, L1_ICache, L2Cache, None
    elif options.smt_model:
        dcache_class_smt1, icache_class_smt1, dcache_class_smt2, icache_class_smt2, l2_cache_class_smt1, l2_cache_class_smt2, l3_cache_class, walk_cache_class = \
            L1DCacheSmt, L1ICacheSmt, L1DCacheSmt, L1ICacheSmt, L2CacheSmtCpu, L2CacheSmtCpu, L3CacheSmt, None
    else:
        dcache_class, icache_class, l2_cache_class, walk_cache_class = \
            L1_DCache, L1_ICache, L2Cache, None

        if buildEnv['TARGET_ISA'] in ['x86', 'riscv']:
            walk_cache_class = PageTableWalkerCache

    # Set the cache line size of the system
    system.cache_line_size = options.cacheline_size

    # If elastic trace generation is enabled, make sure the memory system is
    # minimal so that compute delays do not include memory access latencies.
    # Configure the compulsory L1 caches for the O3CPU, do not configure
    # any more caches.
    if options.l2cache and options.elastic_trace_en:
        fatal("When elastic trace is enabled, do not configure L2 caches.")

    #if options.l2cache:
    # Add L3 cache (for IDIO)
    if options.l3cache:
        if not options.l2cache:
            fatal("L3 cache cannot exist without L2 cache")

        if options.smt_model:
            system.l3 = l3_cache_class(clk_domain = system.cpu_clk_domain,
                                        size = options.l3_size,
                                        assoc = options.l3_assoc)
        else:
            system.l3 = l2_cache_class(clk_domain = system.cpu_clk_domain,
                                    size = options.l3_size,
                                    assoc = options.l3_assoc)
        if options.disable_snoop_filter:
            system.tol3bus = L3XBar(clk_domain = system.clk_domain, snoop_filter = NULL)
        else:
            system.tol3bus = L3XBar(clk_domain = system.clk_domain,
            snoop_filter=SnoopFilter(lookup_latency = 0, is_for_l3x = True, max_capacity="32MB"))
        if options.smt_model:
            system.l3.connectCPUSideBus(system.tol3bus) 
            system.l3.connectMemSideBus(system.membus)
            # system.tol2bus0 = L2XBar(clk_domain = system.cpu_clk_domain)
            # # system.tol2bus1 = L2XBar(clk_domain = system.cpu_clk_domain)
            # system.l3.cpu_side = system.tol3bus.master
            # system.l3.mem_side = system.membus.slave
        else:
            system.l3.cpu_side = system.tol3bus.master
            system.l3.mem_side = system.membus.slave

    elif options.l2cache:
        # Provide a clock for the L2 and the L1-to-L2 bus here as they
        # are not connected using addTwoLevelCacheHierarchy. Use the
        # same clock as the CPUs.
        if options.smt_model:
            system.l2 = l3_cache_class(clk_domain=system.cpu_clk_domain,
                                   **_get_cache_opts('l2', options))
            
            system.tol2bus = L2XBar(clk_domain = system.cpu_clk_domain)
            system.l2.connectCPUSideBus(system.tol2bus)
            system.l2.connectMemSideBus(system.membus)
        else:
            system.l2 = l2_cache_class(clk_domain=system.cpu_clk_domain,
                                   **_get_cache_opts('l2', options))

            system.tol2bus = L2XBar(clk_domain = system.cpu_clk_domain)
            system.l2.cpu_side = system.tol2bus.master
            system.l2.mem_side = system.membus.slave

    if options.memchecker:
        system.memchecker = MemChecker()
    
    for i in range(0,options.num_cpus,2):
        print(f"run: {i}")
        if options.caches:
            # JOHNSON
            if options.smt_model:
                icache_smt_1 = icache_class_smt1(**_get_cache_opts('l1i', options))
                dcache_smt_1 = dcache_class_smt1(**_get_cache_opts('l1d', options))
                icache_smt_2 = icache_class_smt2(**_get_cache_opts('l1i', options))
                dcache_smt_2 = dcache_class_smt2(**_get_cache_opts('l1d', options))
            elif options.smt:
                icache_smt1 = icache_class(**_get_cache_opts('l1i', options))
                dcache_smt1 = dcache_class(**_get_cache_opts('l1d', options))
                icache_smt2 = icache_class_smt(**_get_cache_opts('l1i', options))
                dcache_smt2 = dcache_class_smt(**_get_cache_opts('l1d', options))
            else:
                icache = icache_class(**_get_cache_opts('l1i', options))
                dcache = dcache_class(**_get_cache_opts('l1d', options))

            # SHIN make L2 as MLC of IDIO
            if options.mlc_adaptive_ddio:
                l2 = l2_cache_class(size=options.l2_size, assoc=options.l2_assoc, is_mlc=True, mlc_idx = i, mlc_ddio = True,
                                    prefetcher=MultiPrefetcher(
                                        prefetchers=[StridePrefetcher(degree=8, latency = 1),
                                                    MlcPrefetcher()]))
            else:
                if options.smt_model:
                    l2_smt1 = l2_cache_class_smt1(size=options.l2_size, assoc=options.l2_assoc)
                    l2_smt2 = l2_cache_class_smt2(size=options.l2_size, assoc=options.l2_assoc)
                else:
                    l2 = l2_cache_class(size=options.l2_size, assoc=options.l2_assoc)

            # If we have a walker cache specified, instantiate two
            # instances here
            if walk_cache_class:
                iwalkcache = walk_cache_class()
                dwalkcache = walk_cache_class()
            else:
                iwalkcache = None
                dwalkcache = None

            if options.memchecker:
                dcache_mon = MemCheckerMonitor(warn_only=True)
                dcache_real = dcache

                # Do not pass the memchecker into the constructor of
                # MemCheckerMonitor, as it would create a copy; we require
                # exactly one MemChecker instance.
                dcache_mon.memchecker = system.memchecker

                # Connect monitor
                dcache_mon.mem_side = dcache.cpu_side

                # Let CPU connect to monitors
                dcache = dcache_mon

            # When connecting the caches, the clock is also inherited
            # from the CPU in question
            
            # SHIN.
            # system.cpu[i].addPrivateSplitL1Caches(icache, dcache,
            #                                      iwalkcache, dwalkcache)

            if options.l3cache:
                if options.smt: # JOHNSON
                    system.cpu[i].addTwoLevelCacheHierarchyMerged(icache_smt1, dcache_smt1, icache_smt2, dcache_smt2, system.cpu[i+1],l2)
                elif options.smt_model: # JOHNSON
                    # Connect up icaches, dcaches and l2cache for a 2-cpu cluster sharing the L1 Caches and L2 Cache (Three-Level)
                    # Specify L2 XBar
                    # tol2bus_instance = L2XBar(clk_domain = system.cpu_clk_domain)
                    # system._tol2bus.append(tol2bus_instance)
                    if i == 0:
                        system.tol2bus0 = L2XBar(clk_domain = system.cpu_clk_domain)
                    else:
                        system.tol2bus1 = L2XBar(clk_domain = system.cpu_clk_domain)
                    # system.tol2bus = L2XBar(clk_domain = system.cpu_clk_domain)
                    # system.cpu[i].tol2bus = L2XBar(clk_domain = system.cpu_clk_domain)
                    # system.cpu[i+1].tol2bus = L2XBar(clk_domain = system.cpu_clk_domain)
                    # shared icache
                    system.cpu[i].icache = icache_smt_1
                    system.cpu[i+1].icache = icache_smt_2
                    system.cpu[i].icache.connectCPU(system.cpu[i])
                    system.cpu[i+1].icache.connectCPU(system.cpu[i+1])
                    system.cpu[i]._cached_ports = ['icache.mem_side', 'dcache.mem_side']
                    system.cpu[i+1]._cached_ports = ['icache.mem_side', 'dcache.mem_side']
                    system.cpu[i]._cached_ports += ArchMMU.walkerPorts()
                    system.cpu[i+1]._cached_ports += ArchMMU.walkerPorts()

                    # hook up icaches to the L2 XBar
                    # system.cpu[i].icache.connectBus(system.tol2bus)
                    # system.cpu[i+1].icache.connectBus(system.tol2bus)
                    if i == 0:
                        system.cpu[i].icache.connectBus(system.tol2bus0)
                        system.cpu[i+1].icache.connectBus(system.tol2bus0)
                    else:
                        system.cpu[i].icache.connectBus(system.tol2bus1)
                        system.cpu[i+1].icache.connectBus(system.tol2bus1)
                    # system.cpu[i].icache.connectBus(system.cpu[i].tol2bus)
                    # system.cpu[i+1].icache.connectBus(system.cpu[i].tol2bus)
                    # shared dcache
                    system.cpu[i].dcache = dcache_smt_1
                    system.cpu[i+1].dcache = dcache_smt_2
                    system.cpu[i].dcache.connectCPU(system.cpu[i])
                    system.cpu[i+1].dcache.connectCPU(system.cpu[i+1])
                    # hook up dcaches to the L2 XBar
                    # system.cpu[i].dcache.connectBus(system.tol2bus)
                    # system.cpu[i+1].dcache.connectBus(system.tol2bus)
                    if i == 0:
                        system.cpu[i].dcache.connectBus(system.tol2bus0)
                        system.cpu[i+1].dcache.connectBus(system.tol2bus0)
                    else:
                        system.cpu[i].dcache.connectBus(system.tol2bus1)
                        system.cpu[i+1].dcache.connectBus(system.tol2bus1)
                    # system.cpu[i].dcache.connectBus(system.cpu[i].tol2bus)
                    # system.cpu[i+1].dcache.connectBus(system.cpu[i].tol2bus)
                    # hook up walkerports to the L2 XBar
                    # system.cpu[i].mmu.itb_walker.port = system.tol2bus.cpu_side_ports
                    # system.cpu[i].mmu.dtb_walker.port = system.tol2bus.cpu_side_ports
                    # system.cpu[i+1].mmu.itb_walker.port = system.tol2bus.cpu_side_ports
                    # system.cpu[i+1].mmu.dtb_walker.port = system.tol2bus.cpu_side_ports
                    if i == 0:
                        system.cpu[i].mmu.itb_walker.port = system.tol2bus0.cpu_side_ports
                        system.cpu[i].mmu.dtb_walker.port = system.tol2bus0.cpu_side_ports
                        system.cpu[i+1].mmu.itb_walker.port = system.tol2bus0.cpu_side_ports
                        system.cpu[i+1].mmu.dtb_walker.port = system.tol2bus0.cpu_side_ports
                    else:
                        system.cpu[i].mmu.itb_walker.port = system.tol2bus1.cpu_side_ports
                        system.cpu[i].mmu.dtb_walker.port = system.tol2bus1.cpu_side_ports
                        system.cpu[i+1].mmu.itb_walker.port = system.tol2bus1.cpu_side_ports
                        system.cpu[i+1].mmu.dtb_walker.port = system.tol2bus1.cpu_side_ports
                    # system.cpu[i].mmu.itb_walker.port = system.cpu[i].tol2bus.cpu_side_ports
                    # system.cpu[i].mmu.dtb_walker.port = system.cpu[i].tol2bus.cpu_side_ports
                    # system.cpu[i+1].mmu.itb_walker.port = system.cpu[i].tol2bus.cpu_side_ports
                    # system.cpu[i+1].mmu.dtb_walker.port = system.cpu[i].tol2bus.cpu_side_ports
                    # shared L2 Cache
                    if i == 0:
                        system.l2cache1 = l2_smt1
                    else:
                        system.l2cache2 = l2_smt2
                    # system.cpu[i].l2cache = l2_smt1
                    # system.cpu[i+1].l2cache = l2_smt2 # An extra l2cache may not be needed
                    # hook up l2cache to the L2 XBar
                    if i == 0:
                        system.l2cache1.connectCPUSideBus(system.tol2bus0)
                    else:
                        system.l2cache2.connectCPUSideBus(system.tol2bus1)
                    # system.l2cache.connectCPUSideBus(system.tol2bus)
                    # system.cpu[i].l2cache.connectCPUSideBus(system.cpu[i].tol2bus)
                    # system.cpu[i+1].l2cache.connectCPUSideBus(system.cpu[i+1].tol2bus)
                    system.cpu[i]._cached_ports = ['l2cache.mem_side']
                    system.cpu[i+1]._cached_ports = ['l2cache.mem_side']
                    # hook up l2cache to the L3 XBar
                    # system.l2cache.connectMemSideBus(system.tol3bus)
                    if i == 0:
                        print("here1")
                        system.l2cache1.connectMemSideBus(system.tol3bus)
                    else:
                        print("here")
                        system.l2cache2.connectMemSideBus(system.tol3bus)
                    # system.cpu[i].l2cache.connectMemSideBus(system.tol3bus)
                    # system.cpu[i+1].l2cache.connectMemSideBus(system.tol3bus)
                else:
                    system.cpu[i].addTwoLevelCacheHierarchy(icache, dcache, l2)
                    system.cpu[i+1].addTwoLevelCacheHierarchy(icache, dcache, l2)
            else:
                if options.smt_model:
                    # Connect up icaches, dcaches for a 2-CPU cluster sharing the L1 Caches (Two-Level)
                    # If here, L2 XBar is already specified
                    # shared icache
                    system.cpu[i].icache = icache_smt_1
                    system.cpu[i+1].icache = icache_smt_2
                    system.cpu[i].icache.connectCPU(system.cpu[i])
                    system.cpu[i+1].icache.connectCPU(system.cpu[i+1])
                    # hook up icaches to the L2 XBar
                    system.cpu[i].icache.connectBus(system.cpu[i].tol2bus)
                    system.cpu[i+1].icache.connectBus(system.tol2bus)
                    # shared dcaches
                    system.cpu[i].dcache = dcache_smt_1
                    system.cpu[i+1].dcache = dcache_smt_2
                    system.cpu[i].dcache.connectCPU(system.cpu[i])
                    system.cpu[i+1].dcache.connectCPU(system.cpu[i+1])
                    # hook up dcaches to the L2 XBar
                    system.cpu[i].dcache.connectBus(system.cpu[i].tol2bus)
                    system.cpu[i+1].dcache.connectBus(system.cpu[i].tol2bus)
                else:
                    system.cpu[i].addPrivateSplitL1Caches(icache, dcache,iwalkcache, dwalkcache)
                    system.cpu[i+1].addPrivateSplitL1Caches(icache, dcache,iwalkcache, dwalkcache)

            if options.memchecker:
                # The mem_side ports of the caches haven't been connected yet.
                # Make sure connectAllPorts connects the right objects.
                system.cpu[i].dcache = dcache_real
                system.cpu[i].dcache_mon = dcache_mon
                system.cpu[i+1].dcache = dcache_real
                system.cpu[i+1].dcache_mon = dcache_mon
        
        elif options.external_memory_system:
            # These port names are presented to whatever 'external' system
            # gem5 is connecting to.  Its configuration will likely depend
            # on these names.  For simplicity, we would advise configuring
            # it to use this naming scheme; if this isn't possible, change
            # the names below.
            if buildEnv['TARGET_ISA'] in ['x86', 'arm', 'riscv']:
                system.cpu[i].addPrivateSplitL1Caches(
                        ExternalCache("cpu%d.icache" % i),
                        ExternalCache("cpu%d.dcache" % i),
                        ExternalCache("cpu%d.itb_walker_cache" % i),
                        ExternalCache("cpu%d.dtb_walker_cache" % i))
                system.cpu[i+1].addPrivateSplitL1Caches(
                        ExternalCache("cpu%d.icache" % i),
                        ExternalCache("cpu%d.dcache" % i),
                        ExternalCache("cpu%d.itb_walker_cache" % i),
                        ExternalCache("cpu%d.dtb_walker_cache" % i))
            else:
                system.cpu[i].addPrivateSplitL1Caches(
                        ExternalCache("cpu%d.icache" % i),
                        ExternalCache("cpu%d.dcache" % i))
                system.cpu[i+1].addPrivateSplitL1Caches(
                        ExternalCache("cpu%d.icache" % i),
                        ExternalCache("cpu%d.dcache" % i))
            
        system.cpu[i].createInterruptController()
        system.cpu[i+1].createInterruptController()
        if options.l3cache:
            if options.smt_model:
                continue
            else:
                system.cpu[i].connectAllPorts(system.tol3bus, system.membus)
            # system.cpu[i+1].connectAllPorts(system.tol3bus, system.membus)
        elif options.l2cache:
            system.cpu[i].connectAllPorts(system.tol2bus, system.membus)
            # system.cpu[i+1].connectAllPorts(system.tol2bus, system.membus)
        elif options.external_memory_system:
            system.cpu[i].connectUncachedPorts(system.membus)
            # system.cpu[i+1].connectUncachedPorts(system.membus)
        else:
            system.cpu[i].connectAllPorts(system.membus)
            # system.cpu[i+1].connectAllPorts(system.membus)
        
    return system

# ExternalSlave provides a "port", but when that port connects to a cache,
# the connecting CPU SimObject wants to refer to its "cpu_side".
# The 'ExternalCache' class provides this adaptation by rewriting the name,
# eliminating distracting changes elsewhere in the config code.
class ExternalCache(ExternalSlave):
    def __getattr__(cls, attr):
        if (attr == "cpu_side"):
            attr = "port"
        return super(ExternalSlave, cls).__getattr__(attr)

    def __setattr__(cls, attr, value):
        if (attr == "cpu_side"):
            attr = "port"
        return super(ExternalSlave, cls).__setattr__(attr, value)

def ExternalCacheFactory(port_type):
    def make(name):
        return ExternalCache(port_data=name, port_type=port_type,
                             addr_ranges=[AllMemory])
    return make
