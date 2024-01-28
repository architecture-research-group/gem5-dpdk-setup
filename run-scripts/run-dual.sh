#!/bin/bash
#wbWidth=4 causes error when you run
CACHE_CONFIG="--caches --l2cache --l3cache --l3_size 16MB --l3_assoc 16 --ddio-enabled --l1i_size=64kB --l1i_assoc=4 \
--l1d_size=64kB --l1d_assoc=4 --l2_size=1MB --l2_assoc=8 --cacheline_size=64" 
CPU_CONFIG="--param=testsys.cpu[0:4].l2cache.mshrs=46 --param=testsys.cpu[0:4].dcache.mshrs=20 \
  --param=testsys.cpu[0:4].icache.mshrs=20 --param=testsys.switch_cpus[0:4].decodeWidth=4 \
  --param=testsys.switch_cpus[0:4].numROBEntries=128 --param=testsys.switch_cpus[0:4].numIQEntries=120 \
  --param=testsys.switch_cpus[0:4].LQEntries=68 --param=testsys.switch_cpus[0:4].SQEntries=72 \
  --param=testsys.switch_cpus[0:4].numPhysIntRegs=256 --param=testsys.switch_cpus[0:4].numPhysFloatRegs=256 \
  --param=testsys.switch_cpus[0:4].branchPred.BTBEntries=8192 --param=testsys.switch_cpus[0:4].issueWidth=8 \
  --param=testsys.switch_cpus[0:4].commitWidth=8 --param=testsys.switch_cpus[0:4].dispatchWidth=8 \
  --param=testsys.switch_cpus[0:4].fetchWidth=4 --param=testsys.switch_cpus[0:4].wbWidth=8 \
  --param=testsys.switch_cpus[0:4].squashWidth=8 --param=testsys.switch_cpus[0:4].renameWidth=8"

function usage {
  echo "Usage: $0 --num-nics <num_nics> [--script <script>] [--packet-rate <packet_rate>] [--packet-size <packet_size>] [--loadgen-find-bw] [--take-checkpoint] [-h|--help]"
  echo "  --num-nics <num_nics> : number of NICs to use"
  echo "  --script <script> : guest script to run"
  echo "  --packet-rate <packet_rate> : packet rate in PPS"
  echo "  --packet-size <packet_size> : packet size in bytes"
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
  "$GEM5_DIR"/configs/example/fs_dual.py --dual --cpu-type=$CPUTYPE \
  --kernel="$RESOURCES/vmlinux"  --disk="$RESOURCES/rootfs.ext2" --bootloader="$RESOURCES/boot.arm64" --root=/dev/sda \
  --num-cpus=$(($num_nics+1)) --mem-type=DDR4_2400_16x4 --mem-channels=4 --mem-size=8192MB --script="$GUEST_SCRIPT_DIR/$GUEST_SCRIPT" \
  --drivenode-script="$GUEST_SCRIPT_DIR/$DRIVE_SCRIPT" --checkpoint-dir="$CKPT_DIR" $CONFIGARGS --num-work-ids 0
}

if [[ -z "${GIT_ROOT}" ]]; then
  echo "Please export env var GIT_ROOT to point to the root of the CAL-DPDK-GEM5 repo"
  exit 1
fi

GEM5_DIR=${GIT_ROOT}/gem5
# RESOURCES=${GIT_ROOT}/resources-new
RESOURCES=${GIT_ROOT}/resources-pktgen-pkt
GUEST_SCRIPT_DIR=${GIT_ROOT}/guest-scripts

# parse command line arguments
TEMP=$(getopt -o 'h' --long take-checkpoint,num-nics:,script:,drivenode-script:,freq:,help -n 'dpdk-loadgen' -- "$@")

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
  --take-checkpoint)
    checkpoint=1
    shift 1
    ;;
  --script)
    GUEST_SCRIPT="$2"
    shift 2
    ;;
   --drivenode-script)
    DRIVE_SCRIPT="$2"
    shift 2
    ;;
  --freq)
    Freq=$2
    shift 2
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

CKPT_DIR=${GIT_ROOT}/ckpts-with-new-vmlinux-buildroot-2023/$num_nics"NIC"-$DRIVE_SCRIPT
#CKPT_DIR=${GIT_ROOT}/ckpts/"ckpts-with-new-vmlinux"/$num_nics"NIC"-$GUEST_SCRIPT
if [[ -z "$num_nics" ]]; then
  echo "Error: missing argument --num-nics" >&2
  usage
fi

if [[ -n "$checkpoint" ]]; then
  # RUNDIR=${GIT_ROOT}/rundir/$num_nics"NIC-ckp"-$GUEST_SCRIPT
  RUNDIR=${GIT_ROOT}/rundir/ISPASS-2024-buildroot-2023/$num_nics"NIC-ckp"-$DRIVE_SCRIPT
  setup_dirs
  echo "Taking Checkpoint for NICs=$num_nics" >&2
  GEM5TYPE="fast"
  # DEBUG_FLAGS="--debug-flags=EthernetAll"
  # packet-size = 0 leads to segfault
  PACKET_SIZE=128
  CPUTYPE="AtomicSimpleCPU"
  CONFIGARGS="--max-checkpoints 4 --cpu-clock=$Freq"
  # CONFIGARGS="-r 1 --max-checkpoints 3 --cpu-clock=$Freq"
  run_simulation > ${RUNDIR}/simout
  exit 0
else
  #if [[ -z "$PACKET_SIZE" ]]; then
   # echo "Error: missing argument --packet_size" >&2
   # usage
  #fi

  #if [[ -z "$PACKET_RATE" ]]; then
  #  echo "Error: missing argument --packet_rate" >&2
  #  usage
  #fi
  ((RATE = PACKET_RATE * PACKET_SIZE * 8 / 1024 / 1024 / 1024))
  RUNDIR=${GIT_ROOT}/rundir/iperf-o3-drive-exp/$num_nics"NIC"-$GUEST_SCRIPT-$Freq"-ddio-enabled"
  setup_dirs
# /dpdk-testpmd-freq-scaling-test
  echo "Running NICs=$num_nics at $RATE GBPS" >&2
  CPUTYPE="O3_ARM_v7a_3"
  GEM5TYPE="opt"
  LOADGENMODE=${LOADGENMODE:-"Static"}
  DEBUG_FLAGS="--debug-flags=LoadgenDebug" #--debug-start=33952834348" #EthernetAll,EthernetDesc,LoadgenDebug
  CONFIGARGS="$CACHE_CONFIG $CPU_CONFIG -r 4 --cpu-clock=$Freq" # \
  #--warmup-dpdk 200000000000"
  run_simulation > ${RUNDIR}/simout
  exit
fi
