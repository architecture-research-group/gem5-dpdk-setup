ip link set dev eth0 down
modprobe uio_pci_generic
dpdk-devbind.py -b uio_pci_generic 00:02.0
echo 2048 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
{ sleep 25; m5 checkpoint; } &
dpdk-testpmd -l 0-1 -n 4 -- --nb-cores=1 --coremask=0x02 --forward-mode=macswap --txd=1024 --rxd=1024
