DPDK_PKTGEN_VERSION:=20.11.3
DPDK_PKTGEN_SITE:="$(BR2_EXTERNAL_DPDK_GEM5_PATH)/package/dpdk_pktgen/pktgen-source"
DPDK_PKTGEN_SITE_METHOD:=local
DPDK_PKTGEN_INSTALL_TARGET:=YES
#DPDK_PKTGEN_DEPENDENCIES:= libpcap

define DPDK_PKTGEN_BUILD_CMDS
	export RTE_SDK="$(BR2_EXTERNAL_DPDK_GEM5_PATH)/package/dpdk/dpdk-source"
	export RTE_TARGET=arm64-armv8-linux-gcc
	$(MAKE) clean buildlua -C $(@D)
endef

define DPDK_PKTGEN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/Builddir/app/pktgen $(TARGET_DIR)/usr/bin
	#$(INSTALL) -D -m 0644 $(@D)/cfgs/*.pkt $(TARGET_DIR)/opt
	#$(INSTALL) -D -m 0644 $(@D)/test/* $(TARGET_DIR)/opt
	$(INSTALL) -D -m 0755 $(@D)/libdep/* $(TARGET_DIR)/usr/lib
	#cp -r $(@D) $(TARGET_DIR)/opt
endef	

$(eval $(generic-package))
