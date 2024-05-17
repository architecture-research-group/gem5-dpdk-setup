ip link set dev eth0 down
modprobe uio_pci_generic
dpdk-devbind.py -b uio_pci_generic 00:02.0
mkdir /dev/hugepages    # sometimes not requred
dpdk-hugepages.py --setup 2M   # sometimes not requred
echo 2048 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
# m5 checkpoint

# sleep 3
echo "Starting memcached client in DPDK mode"
memcached_client_dpdk --server_mac=00:90:00:00:00:02 --batching=1 --dataset_size=1000 \
--dataset_key_size="10-100-0.9" --dataset_val_size="10-100-0.9" --populate_workload_size=500 \
--workload_config="500-0.8" --check_get_correctness=false
