DPDK_VERSION:=20.11.3
DPDK_SITE:="$(BR2_EXTERNAL_DPDK_GEM5_PATH)/package/dpdk/dpdk-source"
DPDK_SITE_METHOD:=local
DPDK_INSTALL_TARGET:=YES
DPDK_CONF_OPTS += -Dexamples=all

#define DPDK_INSTALL_TARGET_CMDS
	#/home/ubuntu/CAL-DPDK-GEM5/applications/buildroot/output/host/bin/ninja -j11 -C /home/ubuntu/CAL-DPDK-GEM5/applications/buildroot/output/build/dpdk-20.11.3//build install
	#cp -r $(@D) $(TARGET_DIR)/opt
#endef

$(eval $(meson-package))
