#!/bin/bash
GIT_ROOT=/home/c834u979/ispass-2024/CAL-DPDK-GEM5
GEM5_DIR=${GIT_ROOT}/gem5
RESOURCES=${GIT_ROOT}/resources-dpdk
GUEST_SCRIPT_DIR=${GIT_ROOT}/guest-scripts

CACHE_CONFIG="--caches --l2cache --l3cache --l3_size 16MB --l3_assoc 16 --ddio-enabled --l1i_size=64kB --l1i_assoc=4 \
--l1d_size=64kB --l1d_assoc=4 --l2_size=1MB --l2_assoc=8 --cacheline_size=64"
CPU_CONFIG="--param=testsys.cpu[0:4].l2cache.mshrs=46 --param=testsys.cpu[0:4].dcache.mshrs=20 \
  --param=testsys.cpu[0:4].icache.mshrs=20 --param=testsys.l3.ddio_way_part=4 \
  --param=testsys.switch_cpus_1[0:4].decodeWidth=4 --param=testsys.l3.is_llc=True \
  --param=testsys.switch_cpus_1[0:4].numROBEntries=128 --param=testsys.switch_cpus_1[0:4].numIQEntries=120 \
  --param=testsys.switch_cpus_1[0:4].LQEntries=68 --param=testsys.switch_cpus_1[0:4].SQEntries=72 \
  --param=testsys.switch_cpus_1[0:4].numPhysIntRegs=256 --param=testsys.switch_cpus_1[0:4].numPhysFloatRegs=256 \
  --param=testsys.switch_cpus_1[0:4].branchPred.BTBEntries=8192 --param=testsys.switch_cpus_1[0:4].issueWidth=8 \
  --param=testsys.switch_cpus_1[0:4].commitWidth=8 --param=testsys.switch_cpus_1[0:4].dispatchWidth=8 \
  --param=testsys.switch_cpus_1[0:4].fetchWidth=4 --param=testsys.switch_cpus_1[0:4].wbWidth=8 \
  --param=testsys.switch_cpus_1[0:4].squashWidth=8 --param=testsys.switch_cpus_1[0:4].renameWidth=8"

FS_CONFIG=$GEM5_DIR/configs/example/fs.py
SW_CONFIG=$GEM5_DIR/configs/dist/sw.py
GEM5_EXE=$GEM5_DIR/build/ARM/gem5.fast
#DEBUG_FLAGS="--debug-flags=DistEthernet"

function run_dist_simulation {
    echo "Starting dist simulation"
    "$GEM5_DIR"/util/dist/gem5-dist.sh -n 2 \
    -r "$RUNDIR" -c "$CKPT_DIR" \
    -s "$SW_CONFIG" -f "$FS_CONFIG" -x "$GEM5_EXE" \
    --fs-args \
    --kernel="$RESOURCES/vmlinux" --disk="$RESOURCES/rootfs.ext2" --bootloader="$RESOURCES/boot.arm64" --root=/dev/sda \
    --num-cpus=1 --mem-type=DDR4_2400_16x4 --mem-channels=4 --mem-size=16384MB --script="$GUEST_SCRIPT_DIR/$GUEST_SCRIPT" \
    --num-nics="$num_nics" $CONFIGARGS --cpu-type=$CPUTYPE \
    --cf-args "-r1" 
    
    #--cpu-type=$CPUTYPE \
    #--kernel="$RESOURCES/vmlinux" --disk="$RESOURCES/rootfs.ext2" --bootloader="$RESOURCES/boot.arm64" --root=/dev/sda \
    #--num-cpus=1 --mem-size=8192MB --script="$GUEST_SCRIPT_DIR/$GUEST_SCRIPT" \
    #--num-nics="$num_nics" \
    #$CONFIGARGS
}

function setup_dirs {
  mkdir -p "$CKPT_DIR"
  mkdir -p "$RUNDIR"
}

function usage {
  echo "Usage: $0 --num-nics <num_nics> [--script <script>] [--take-checkpoint] [-h|--help]"
  echo "  --num-nics <num_nics> : number of NICs to use"
  echo "  --script <script> : guest script to run"
  echo "  --take-checkpoint : take checkpoint after running"
  echo "  -h --help : print this message"
  exit 1
}

# parse command line arguments
TEMP=$(getopt -o 'h' --long take-checkpoint,num-nics:,freq:,script:,help -n 'iperf-dist' -- "$@")

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


if [[ -z "$num_nics" ]]; then
  echo "Error: missing argument --num-nics" >&2
  usage
fi

CKPT_DIR=${GIT_ROOT}/rundir/ISPASS-2024/$num_nics"NIC-ckp"-"iperf-1.sh2"


if [[ -n "$checkpoint" ]]; then
  RUNDIR=${GIT_ROOT}/rundir/ISPASS-2024/$num_nics"NIC-ckp"-$GUEST_SCRIPT/ckp2
  setup_dirs
  echo "Taking Checkpoint for NICs=$num_nics" >&2
  CPUTYPE="AtomicSimpleCPU"
  CONFIGARGS="--cpu-clock=$Freq"
  run_dist_simulation 
  exit 0
else
  #if [[ -z "$PACKET_SIZE" ]]; then
  #  echo "Error: missing argument --packet_size" >&2
  #  usage
  #fi

  #if [[ -z "$PACKET_RATE" ]]; then
  #  echo "Error: missing argument --packet_rate" >&2
  #  usage
  #fi
  GEM5_EXE=$GEM5_DIR/build/ARM/gem5.opt
  RUNDIR=${GIT_ROOT}/rundir/ISPASS-2024/$num_nics"NIC-ckp"-"iperf-1.sh2"/freq-exp/rundir-$GUEST_SCRIPT-$Freq
  setup_dirs
  CPUTYPE="O3_ARM_v7a_3"
  CONFIGARGS="$CACHE_CONFIG $CPU_CONFIG --cpu-clock=$Freq --standard-switch 300000000000 --warmup-dpdk 1"
  run_dist_simulation
  exit 0
fi
