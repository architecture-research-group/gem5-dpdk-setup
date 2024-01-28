ip link set dev eth0 down
modprobe uio_pci_generic
dpdk-devbind.py -b uio_pci_generic 00:02.0
echo 2048 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
{ sleep 150; m5 checkpoint; } &
dpdk-testpmd -l 0-3 -n 4 -- --nb-cores=3 --forward-mode=macswap --txd=1024 --rxd=1024