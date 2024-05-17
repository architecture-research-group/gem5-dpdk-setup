#!/bin/bash
COUNT=$(bc -l <<< "$3 * $2/($1 * 8) * 10^9")
echo "set 0 dst mac 0c:42:a1:e7:1f:6a"
echo "set 0 size $1"
echo "set 0 rate $2gbps"
#echo "set 0 count $COUNT"
echo "start 0"
echo "sleep $(bc -l <<< "2 + $3 * 1.5")"
echo "quit"


