#!/bin/sh

function hibench_configure {
	grep -q "$HADOOP_PATH" ${HIBENCH_PATH}/conf/hadoop.conf && return 0

	echo "hibench not configured, start configuring ..."

	cp config/hibench/hadoop.conf ${HIBENCH_PATH}/conf/hadoop.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/conf/hadoop.conf
}

function system_configure {
	ulimit -n 102400
	echo never > /sys/kernel/mm/transparent_hugepage/defrag
	echo 0 > /proc/sys/kernel/numa_balancing
	echo 0 > /proc/sys/vm/swappiness
	echo 0 > /proc/sys/kernel/sched_autogroup_enabled
	echo 3000 > /proc/sys/vm/dirty_expire_centisecs
	echo 40 > /proc/sys/vm/dirty_ratio
	echo 10240 > /proc/sys/net/core/somaxconn
	echo 5000000 > /proc/sys/kernel/sched_migration_cost_ns
	service irqbalance stop
}

function system_restore {
	echo 60000 > /proc/sys/kernel/numa_balancing_scan_period_max_ms
	echo 1 > /proc/sys/kernel/numa_balancing
	echo 1 > /proc/sys/kernel/sched_autogroup_enabled
	echo 0 > /proc/sys/vm/swappiness
	echo 500000 > /proc/sys/kernel/sched_migration_cost_ns
}

function delete_tmp_dirs {
	hdfs dfs -rm -r /HiBench
}

workloads_list=( \
	"micro/wordcount" \
	"micro/terasort" \
	"micro/sort" \
	"websearch/pagerank" \
	"micro/dfsioe" \
	"sql/scan" "ml/kmeans" \
) 
num_map=("64" "32" "32" "64" "32" "32" "64")
num_red=("64" "32" "32" "32" "32" "32" "64")
scale_list=("huge" "huge" "huge" "huge" "huge" "huge" "huge")

function run_workload {
	local workload=${1}
	local scale=${2}
	local map=${3-32}
	local red=${4-32}

	sed -i "s/hibench\.scale\.profile.*/hibench\.scale\.profile\ ${scale}/g" \
		${HIBENCH_PATH}/conf/hibench.conf
	sed -i "s/hibench\.default\.map.*/hibench\.default\.map\.parallelism\ ${map}/g" \
		${HIBENCH_PATH}/conf/hibench.conf
	sed -i "s/hibench\.default\.shuffle.*/hibench\.default\.shuffle\.parallelism\ ${red}/g" \
		${HIBENCH_PATH}/conf/hibench.conf

	delete_tmp_dirs
	echo -e "\nPrepare $workload Data ......"
	${HIBENCH_PATH}/bin/workloads/${workload}/prepare/prepare.sh
	echo -e "\nBegin to execute $workload benchmark ......"
	${HIBENCH_PATH}/bin/workloads/${workload}/hadoop/run.sh
}

function run_hibench {
	local i=${1-0}

	run_workload ${workloads_list[$i]} ${scale_list[$i]} ${num_map[$i]} ${num_red[$i]}
}

function run_hibench_all {
	local i=0
	
	while [[ ${i} -lt ${#workloads_list[@]} ]]; do
		run_workload ${workloads_list[$i]} ${scale_list[$i]} ${num_map[$i]} ${num_red[$i]}
		let "i++"
	done
}
