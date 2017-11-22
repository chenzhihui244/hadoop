#!/bin/bash

if (( $# < 1 )); then
	echo "$0 <log file>"
	exit 1
fi

perf_tools_dir=/local/perf-tools
output_dir=/local
log_file=$output_dir/${1-perf-icache.txt}

echo "perf_tools_dir($perf_tools_dir), output_dir($output_dir), start tracing..."

cd $perf_tools_dir && \
./bin/kprobe 'p:sync_icache_aliases addr=%x0:x64 len=%x1:x64' > $log_file

