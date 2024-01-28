ip link set dev eth0 down
modprobe uio_pci_generic
dpdk-devbind.py -b uio_pci_generic 00:02.0
mkdir /dev/hugepages    # sometimes not requred
dpdk-hugepages.py --setup 2M   # sometimes not requred
echo 2048 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
# m5 checkpoint

echo "Starting memcached server in DPDK mode"
memcached_dpdk -u root
