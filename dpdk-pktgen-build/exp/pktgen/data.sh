#!/bin/bash
set -e
source ../../shared.sh

vtune=/opt/intel/oneapi/vtune/latest/bin64/vtune

pktgen=$PKTGEN/usr/local/bin/pktgen

run() {
		echo $1,$2,$3,$(stats --average $(cat "stats/${1}_${2}_${3}.txt")) >> results.csv
}

readarray -t elements < <(cat configs.txt)


for ((i = 0; i < ${#elements[@]}; i += 1)); do 
	SIZE=$(echo ${elements[i]} | grep -o "\w*" | head -1)
	RATE=$(echo ${elements[i]} | grep -o "\w*" | head -2 | tail -1)
	DUR=$(echo ${elements[i]} | grep -o "\w*" | head -3 | tail -1)
	run $SIZE $RATE $DUR

done 

