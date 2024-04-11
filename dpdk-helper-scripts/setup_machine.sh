#!/bin/bash
HUGEPGS=1

#single numa node huge pages
echo $HUGEPGS > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

#enable perf counter monitoring
echo 0 > /proc/sys/kernel/nmi_watchdog
echo -1 > /proc/sys/kernel/perf_event_paranoid
