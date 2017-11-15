#!/bin/sh

. $TOPDIR/scripts/env.sh

function config_hibench
{
	cp config/hibench/bayes_hibench_hadoop.conf $HIBENCH_PATH/workloads/bayes/conf/10-baytes-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/bayes/conf/10-baytes-userdefine.conf

	cp config/hibench/join_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/join/conf/10-join-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/join/conf/10-join-userdefine.conf

	cp config/hibench/aggregation_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/aggregation/conf/10-aggregation-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/aggregation/conf/10-aggregation-userdefine.conf

	cp config/hibench/pagerank_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/pagerank/conf/10-pagerank-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/pagerank/conf/10-pagerank-userdefine.conf

	cp config/hibench/sleep_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/sleep/conf/10-sleep-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/sleep/conf/10-sleep-userdefine.conf

	cp config/hibench/scan_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/scan/conf/10-scan-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/scan/conf/10-scan-userdefine.conf

	cp config/hibench/dfsioe_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/dfsioe/conf/10-dfsioe-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/dfsioe/conf/10-dfsioe-userdefine.conf

	cp config/hibench/wordcount_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/wordcount/conf/10-wordcount-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/wordcount/conf/10-wordcount-userdefine.conf

	cp config/hibench/terasort_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/terasort/conf/10-terasort-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/terasort/conf/10-terasort-userdefine.conf

	cp config/hibench/sort_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/sort/conf/10-sort-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/sort/conf/10-sort-userdefine.conf

	cp config/hibench/kmeans_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/kmeans/conf/10-kmeans-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/kmeans/conf/10-kmeans-userdefine.conf

	cp config/hibench/nutchindexing_hibench_hadoop.conf ${HIBENCH_PATH}/workloads/nutchindexing/conf/10-nuthindexing-userdefine.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/workloads/nutchindexing/conf/10-nuthindexing-userdefine.conf

	cp config/hibench/languages.lst ${HIBENCH_PATH}/conf/languages.lst
	cp config/hibench/10-data-scale-profile.conf ${HIBENCH_PATH}/conf/10-data-scale-profile.conf
	#cp config/hibench/00-default-properties.conf ${HIBENCH_PATH}/config/00-default-properties.conf
	cp config/hibench/99-user_defined_properties.conf ${HIBENCH_PATH}/conf/99-user_defined_properties.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/conf/99-user_defined_properties.conf
}

function hibench_configure_2 {
	grep -q "$HIBENCH_PATH" ${HIBENCH_PATH}/conf/hadoop.conf && return 0

	cp config/hibench/hibench_hadoop.conf ${HIBENCH_PATH}/conf/hadoop.conf
	sed -i "s;hadoop_path;$HADOOP_PATH;g" ${HIBENCH_PATH}/conf/hadoop.conf
}

function system_configure {
	ulimit -n 102400
}

#function system_restore {
#}

function delete_tmp_dirs {
	hdfs dfs -rm -r /HiBench
}

function run_hibench_test {
	echo -e "\nPrepare Data ......"
	${HIBENCH_PATH}/bin/workloads/micro/sort/prepare/prepare.sh
	echo -e "\nBegin to execute benchmark ......"
	${HIBENCH_PATH}/bin/workloads/micro/sort/hadoop/run.sh
}

function run_hibench_case {
	local cas=${1}
	local scale=${2}
	local map=${3-32}
	local red=${4-32}

	sed -i "s/hibench\.scale\.profile.*/hibench\.scale\.profile\ ${scale}/g" \
		${HIBENCH_PATH}/conf/hibench.conf
	sed -i "s/hibench\.default\.map.*/hibench\.default\.map\.parallelism\ ${map}/g" \
		${HIBENCH_PATH}/conf/hibench.conf
	sed -i "s/hibench\.default\.shuffle.*/hibench\.default\.shuffle\.parallelism\ ${red}/g" \
		${HIBENCH_PATH}/conf/hibench.conf

	echo -e "\nPrepare $cas Data ......"
	${HIBENCH_PATH}/bin/workloads/${cas}/prepare/prepare.sh
	echo -e "\nBegin to execute $cas benchmark ......"
	${HIBENCH_PATH}/bin/workloads/${cas}/hadoop/run.sh
}

function run_hibench {
	#caseslist=("micro/wordcount" "micro/terasort" "micro/sort" "websearch/pagerank" "micro/dfsioe" "sql/scan" "ml/kmeans")
	caseslist=("micro/dfsioe")

	for casename in ${caseslist[@]}; do
		delete_tmp_dirs
		run_hibench_case ${casename} large

		#delete_tmp_dirs
		#run_hibench_case ${casename} huge

		#echo "Test Result Report:"
		#cat ${HIBENCH_PATH}/report/hibench.report
	done
}

function run_hibench_all {
	${HIBENCH_PATH}/bin/run-all.sh

	echo "Test Result Report:"
	cat ${HIBENCH_PATH}/report/hibench.report
}

if ! grep -q "HIBENCH_PATH" $TOPDIR/install/etc/profile; then
	echo "hibench not installed"
	exit 1
fi

#config_hibench
system_configure
hibench_configure_2
run_hibench
#run_hibench_test
#run_hibench_all
