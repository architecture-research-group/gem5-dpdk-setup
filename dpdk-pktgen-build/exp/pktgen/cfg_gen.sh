#!/bin/bash
COUNT=$(bc -l <<< "$3 * $2/($1 * 8) * 10^9")
echo "sleep 1.0"
echo "set 0 dst mac 08:c0:eb:bf:ee:b6"
echo "set 0 size $1"
echo "set 0 rate $2gbps"
#echo "set 0 count $COUNT"
echo "start 0"
echo "sleep $(bc -l <<< "2 + $3 * 1.5")"
echo "stop 0"
echo "quit"
