ls opt
cat opt/dpdk_pktgen-20.11.3/test/main-256.lua
export RTE_SDK=opt/dpdk-20.11.3
export RTE_TARGET=arm64-armv8-linux-gcc
# cd opt/dpdk_pktgen-20.11.3/
ip link set dev eth0 down
modprobe uio_pci_generic
dpdk-devbind.py -b uio_pci_generic 00:02.0
echo 2048 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
{ sleep 10; m5 checkpoint; } &
# pktgen -l 0-1 -n 1 -- -m 1.0 -f test/hello-world.lua
pktgen -l 0-1 -n 1 -- -m 1.0 -f opt/256.pkt