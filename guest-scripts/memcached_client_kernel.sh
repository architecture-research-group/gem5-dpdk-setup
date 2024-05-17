ip link set dev eth0 down
# ifconfig eth0 192.17.100.7 netmask 255.255.252.0
ifconfig eth0 192.168.1.2 netmask 255.255.255.0 # IP address (client)
ip link set dev eth0 up
ethtool -G eth0 rx 1024 tx 1024
arp -s 192.168.1.1 00:90:00:00:00:02 # MAC address (server)
# arp -s 192.17.100.243 00:80:00:00:00:01​
sleep 5
echo "Starting memcached client in Kernel mode"
memcached_client_kernel --server_ip=192.168.1.1 --batching=1 --dataset_size=15000 \
--dataset_key_size="10-100-0.9" --dataset_val_size="10-100-0.9" --populate_workload_size=5000 \
--workload_config="10000-0.8" --check_get_correctness=false
