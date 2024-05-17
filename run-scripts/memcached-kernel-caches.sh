#!/bin/bash

CACHE_CONFIG="--caches --l2cache --l3cache --l3_assoc 16 --ddio-disabled --l1i_assoc=4 \
--l1d_assoc=4 --l2_assoc=8 --cacheline_size=64" # --param=system.l3.is_llc=True --param=system.l3.ddio_way_part=4 \
# --param=system.cpu[0:4].l2cache.mshrs=46 --param=system.cpu[0:4].dcache.mshrs=20" 
CPU_CONFIG="--param=system.cpu[0:4].l2cache.mshrs=46 --param=system.cpu[0:4].dcache.mshrs=20 \
  --param=system.cpu[0:4].icache.mshrs=20 --param=system.l3.ddio_way_part=4 \
  --param=system.switch_cpus[0:4].decodeWidth=4 --param=system.l3.is_llc=True \
  --param=system.switch_cpus[0:4].numROBEntries=128 --param=system.switch_cpus[0:4].numIQEntries=120 \
  --param=system.switch_cpus[0:4].LQEntries=68 --param=system.switch_cpus[0:4].SQEntries=72 \
  --param=system.switch_cpus[0:4].numPhysIntRegs=256 --param=system.switch_cpus[0:4].numPhysFloatRegs=256 \
  --param=system.switch_cpus[0:4].branchPred.BTBEntries=8192 --param=system.switch_cpus[0:4].issueWidth=8 \
  --param=system.switch_cpus[0:4].commitWidth=8 --param=system.switch_cpus[0:4].dispatchWidth=8 \
  --param=system.switch_cpus[0:4].fetchWidth=4 --param=system.switch_cpus[0:4].wbWidth=8 \
  --param=system.switch_cpus[0:4].squashWidth=8 --param=system.switch_cpus[0:4].renameWidth=8"

function usage {
  echo "Usage: $0 --num-nics <num_nics> [--script <script>] [--loadgen-find-bw] [--take-checkpoint] [-h|--help]"
  echo "  --num-nics <num_nics> : number of NICs to use"
  echo "  --script <script> : guest script to run"
  echo "  --loadgen-find-bw : run loadgen in find bandwidth mode"
  echo "  --take-checkpoint : take checkpoint after running"
  echo "  -h --help : print this message"
  exit 1
}

function setup_dirs {
  mkdir -p "$CKPT_DIR"
  mkdir -p "$RUNDIR"
}

function run_simulation {
  "$GEM5_DIR/build/ARM/gem5.$GEM5TYPE" $DEBUG_FLAGS --outdir="$RUNDIR" \
  "$GEM5_DIR"/configs/example/fs.py --cpu-type=$CPUTYPE \
  --kernel="$RESOURCES/vmlinux" --disk="$RESOURCES/rootfs.ext2" --bootloader="$RESOURCES/boot.arm64" --root=/dev/sda \
  --num-cpus=$(($num_nics+3)) --mem-type=DDR4_2400_16x4 --mem-channels=$CHANNELS --mem-size=65536MB --script="$GUEST_SCRIPT_DIR/$GUEST_SCRIPT" \
  --num-nics="$num_nics" --num-loadgens="$num_nics" \
  --checkpoint-dir="$CKPT_DIR" $CONFIGARGS
}

if [[ -z "${GIT_ROOT}" ]]; then
  echo "Please export env var GIT_ROOT to point to the root of the CAL-DPDK-GEM5 repo"
  exit 1
fi

GEM5_DIR=${GIT_ROOT}/gem5
# RESOURCES=${GIT_ROOT}/resources
RESOURCES=${GIT_ROOT}/resources-dpdk
GUEST_SCRIPT_DIR=${GIT_ROOT}/guest-scripts

# parse command line arguments
TEMP=$(getopt -o 'h' --long l1-size:,l2-size:,l3-size:,mem-channels:,rob-entries:,freq:,take-checkpoint,cpu-types:,num-nics:,script:,packet-rate:,loadgen-find-bw,help -n 'dpdk-loadgen' -- "$@")

# check for parsing errors
if [ $? != 0 ]; then
  echo "Error: unable to parse command line arguments" >&2
  exit 1
fi

eval set -- "$TEMP"

while true; do
  case "$1" in
  --num-nics)
    num_nics="$2"
    shift 2
    ;;
  --l1-size)
    L1_SIZE="$2"
    shift 2
    ;;
  --l2-size)
    L2_SIZE="$2"
    shift 2
    ;;
  --l3-size)
    L3_SIZE="$2"
    shift 2
    ;;
  --cpu-types)
    CPUTYPE="$2"
    shift 2
    ;;
  --mem-channels)
    CHANNELS=$2
    shift 2
    ;;
  --rob-entries)
    ROB_ENTRIES=$2
    shift 2
    ;;
  --freq)
    FREQ="$2"
    shift 2
    ;;
  --take-checkpoint)
    checkpoint=1
    shift 1
    ;;
  --script)
    GUEST_SCRIPT="$2"
    shift 2
    ;;
  --packet-rate)
    PACKET_RATE="$2"
    shift 2
    ;;
  --loadgen-find-bw)
    LOADGENREPLAYMODE="ReplayAndAdjustThroughput"
    shift 1
    ;;
  -h | --help)
    usage
    ;;
  --)
    shift
    break
    ;;
  *) break ;;
  esac
done
# CKPT_DIR=${GIT_ROOT}/ckpts/$num_nics"NIC"-$GUEST_SCRIPT
CKPT_DIR=${GIT_ROOT}/ckpts/$num_nics"NIC"-$GUEST_SCRIPT
if [[ -z "$num_nics" ]]; then
  echo "Error: missing argument --num-nics" >&2
  usage
fi

if [[ -n "$checkpoint" ]]; then
  # RUNDIR=${GIT_ROOT}/rundir/$num_nics"NIC-ckp-"$GUEST_SCRIPT
  RUNDIR=${GIT_ROOT}/rundir/ISPASS-2024-memcached-exps/$num_nics"NIC-ckp"-$GUEST_SCRIPT
  setup_dirs
  echo "Taking Checkpoint for NICs=$num_nics" >&2
  GEM5TYPE="fast"
  DEBUG_FLAGS="" #"--debug-flags=LoadgenDebug"
  PORT=11211
  CPUTYPE="AtomicSimpleCPU"
  PACKET_RATE=5000
  LOADGENREPLAYMODE=ConstThroughput
  PCAP_FILENAME="../resources-dpdk/warmup-5k.pcap"
  CONFIGARGS="-r 4 --max-checkpoints 1 --checkpoint-at-end --l2_size=$L2_SIZE $CACHE_CONFIG --cpu-clock=$FREQ --loadgen-start=4231917792397 --loadgen-type=Pcap --loadgen_pcap_filename=$PCAP_FILENAME --packet-rate=$PACKET_RATE --loadgen-replymode=$LOADGENREPLAYMODE --loadgen-port-filter=$PORT"
  # CONFIGARGS="--max-checkpoints 2 --l2_size=$L2_SIZE $CACHE_CONFIG --cpu-clock=$FREQ --loadgen-start=6025995323418580 --loadgen-type=Pcap --loadgen_pcap_filename=$PCAP_FILENAME --packet-rate=$PACKET_RATE --loadgen-replymode=$LOADGENREPLAYMODE --loadgen-port-filter=$PORT"
  run_simulation > ${RUNDIR}/simout
  exit 0
else
  if [[ -z "$PACKET_RATE" ]]; then
    echo "Error: missing argument --packet_rate" >&2
    usage
  fi
  # CPU_CONFIG="--param=system.cpu[0:4].l2cache.mshrs=46 --param=system.cpu[0:4].dcache.mshrs=20 \
  # --param=system.cpu[0:4].icache.mshrs=20 --param=system.l3.ddio_way_part=4 \
  # --param=system.switch_cpus[0:4].decodeWidth=4 --param=system.l3.is_llc=True \
  # --param=system.switch_cpus[0:4].numROBEntries=$ROB_ENTRIES --param=system.switch_cpus[0:4].numIQEntries=120 \
  # --param=system.switch_cpus[0:4].LQEntries=68 --param=system.switch_cpus[0:4].SQEntries=72 \
  # --param=system.switch_cpus[0:4].numPhysIntRegs=256 --param=system.switch_cpus[0:4].numPhysFloatRegs=256 \
  # --param=system.switch_cpus[0:4].branchPred.BTBEntries=8192 --param=system.switch_cpus[0:4].issueWidth=8 \
  # --param=system.switch_cpus[0:4].commitWidth=8 --param=system.switch_cpus[0:4].dispatchWidth=8 \
  # --param=system.switch_cpus[0:4].fetchWidth=4 --param=system.switch_cpus[0:4].wbWidth=8 \
  # --param=system.switch_cpus[0:4].squashWidth=8 --param=system.switch_cpus[0:4].renameWidth=8"
  PORT=11211    # for memcached
  PCAP_FILENAME="../resources-dpdk/request-10k.pcap"
  ((INCR_INTERVAL = PACKET_RATE / 10))
  RUNDIR=${GIT_ROOT}/rundir/memcached-kernel-findbw-mem-channels-exp/$num_nics"NIC"-$GUEST_SCRIPT-$FREQ"-ddio-disabled"-$PACKET_RATE-$CHANNELS
  setup_dirs
  CPUTYPE="O3_ARM_v7a_3" # just because DerivO3CPU is too slow sometimes
  GEM5TYPE="opt"
  LOADGENREPLAYMODE=${LOADGENREPLAYMODE:-"ConstThroughput"}
  DEBUG_FLAGS="" #"--debug-flags=LoadgenDebug"
  CONFIGARGS="--l1i_size=$L1_SIZE --l1d_size=$L1_SIZE --l2_size=$L2_SIZE --l3_size $L3_SIZE --cpu-clock=$FREQ $CACHE_CONFIG $CPU_CONFIG -r 5 --loadgen-type=Pcap --loadgen_pcap_filename=$PCAP_FILENAME --loadgen-start=5230327797390 --packet-rate=$PACKET_RATE --loadgen-replymode=$LOADGENREPLAYMODE --loadgen-port-filter=$PORT --loadgen-increment-interva=$INCR_INTERVAL"
  run_simulation > ${RUNDIR}/simout
  exit
fi