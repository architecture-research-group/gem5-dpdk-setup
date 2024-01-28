ip link set dev eth0 down
# ifconfig eth0 192.17.100.7 netmask 255.255.252.0
ifconfig eth0 192.168.1.1 netmask 255.255.255.0 # IP address from altra (server)
ip link set dev eth0 up
ethtool -G eth0 rx 1024 tx 1024
arp -s 192.168.1.2 08:c0:eb:bf:ee:aa # MAC address from pollux (client)
# arp -s 192.17.100.243 00:80:00:00:00:01​
echo "Starting memcached server in Kernel mode"
{ sleep 20; m5 checkpoint; } &
memcached -p 0 -U 11211 -u root
# memcached -p 0 -U 11211 -u root -vvv
# tcpdump -i eth0 -X
