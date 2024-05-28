#!/bin/sh

ip link set eth0 address 00:90:00:00:00:02 #${MY_ADDR}
ip addr add 10.0.0.2/24 dev eth0 #${MY_ADDR}/24 dev eth0
ip link set dev eth0 up

ethtool -G eth0 rx 1024 tx 1024

iperf3 -s -p 5002 -B 10.0.0.2 -1 &

x=1
sleep 0.05
while [ $x -gt 0 ]; do
	echo "Test Node in Iteration $x"
	x=$(($x+1))
    sleep 2
done

m5 exit 1
