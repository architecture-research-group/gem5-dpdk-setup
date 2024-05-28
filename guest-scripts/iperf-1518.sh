#!/bin/sh

ip link set eth0 address 00:90:00:00:00:03 
ip addr add 10.0.0.3/24 dev eth0 
ip link set dev eth0 up

ethtool -G eth0 rx 1024 tx 1024

# ping -c1 -I eth0 10.0.0.2

sleep 0.1
echo "Slept for 0.1s. Taking checkpoint ..."
m5 checkpoint
    
iperf3 -c 10.0.0.2 -t 3 -M 1478  -p 5002 -B 10.0.0.3 

m5 exit 1
