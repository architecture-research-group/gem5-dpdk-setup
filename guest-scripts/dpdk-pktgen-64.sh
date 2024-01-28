ls opt/dpdk_pktgen-20.11.3/test
# cat opt/64.pkt
export RTE_SDK=opt/dpdk-20.11.3
export RTE_TARGET=arm64-armv8-linux-gcc
cd opt/dpdk_pktgen-20.11.3/
ip link set dev eth0 down
modprobe uio_pci_generic
dpdk-devbind.py -b uio_pci_generic 00:02.0
echo 2048 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
{ sleep 7; m5 checkpoint; } &
pktgen -l 0-1 -n 1 -- -m 1.0 -f test/main-64.lua
# pktgen -l 0-1 -n 1 -- -m 1.0 -f opt/64.pkt