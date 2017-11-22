#!/bin/bash

perf_tools_dir=/local/perf-tools
output_dir=/local

echo "perf_tools_dir($perf_tools_dir), output_dir($output_dir), start tracing..."

cd $perf_tools_dir && \
./bin/kprobe 'p:sync_icache_aliases addr=%x0:x64 len=%x1:x64' > $output_dir/install/perf-icache.txt

