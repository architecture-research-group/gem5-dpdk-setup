#!/bin/bash
set -e
source ../../shared.sh

pktgen=$PKTGEN/usr/local/bin/pktgen

run() {
	./cfg_gen.sh $1 $2 $3 > "cfgs/${1}_${2}_${3}.pkt"
}

readarray -t elements < <(cat configs.txt)



while read -u3 a b c; do 
	run $a $b $c
done 3< configs.txt
