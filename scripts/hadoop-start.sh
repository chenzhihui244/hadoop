#!/bin/sh

. $TOPDIR/scripts/env.sh

function config_hadoop
{
	grep -q "$export JAVA_HOME=\${JAVA_HOME}" $HADOOP_PATH/etc/hadoop/hadoop-env.sh || return 0

	# java enviornment update
	sed -i "s;export JAVA_HOME=\${JAVA_HOME};export JAVA_HOME=${JAVA_HOME};g" \
		${HADOOP_PATH}/etc/hadoop/hadoop-env.sh

	cp -f $TOPDIR/config/hadoop/core-site.xml.local ${HADOOP_PATH}/etc/hadoop/core-site.xml
	sed -i "s;hadoop_data;${HADOOP_DATA};g" ${HADOOP_PATH}/etc/hadoop/core-site.xml

	cp -f $TOPDIR/config/hadoop/hdfs-site.xml.local ${HADOOP_PATH}/etc/hadoop/hdfs-site.xml
	sed -i "s;hadoop_data;${HADOOP_DATA};g" ${HADOOP_PATH}/etc/hadoop/hdfs-site.xml

	cp -f $TOPDIR/config/hadoop/mapred-site.xml.local ${HADOOP_PATH}/etc/hadoop/mapred-site.xml

	cp -f $TOPDIR/config/hadoop/yarn-site.xml.local ${HADOOP_PATH}/etc/hadoop/yarn-site.xml
}

function hadoop_status {
	jps | awk 'BEGIN {namenode=0;nodemanager=0;resourcemanager=0;secondarynamenode=0;datanode=0} \
		$2 ~ "NameNode" {namenode=1} \
		$2 ~ "NodeManager" {nodemanager=1} \
		$2 ~ "ResourceManager" {resourcemanager=1} \
		$2 ~ "SecondaryNameNode" {secondarynamenode=1} \
		$2 ~ "DataNode" {datanode=1} \
		END {print (namenode+nodemanager+resourcemanager+secondarynamenode+datanode)}'
}

function stop_local_hadoop {
	while (( `hadoop_status` != 0 )); do
		warn "$HADOOP_PATH/sbin/stop-yarn.sh"
		warn "$HADOOP_PATH/sbin/stop-dfs.sh"
		sleep 1
	done
}

function start_local_hadoop {
	if (( `hadoop_status` == 5 )); then
		echo "hadoop already started"
		return 0
	fi

	echo "stop hadoop first"
	stop_local_hadoop

	rm -rf ${HADOOP_DATA}/tmp/*
	warn "${HADOOP_PATH}/bin/hdfs namenode -format"
	sleep 1

	#warn "$HADOOP_PATH/sbin/start-all.sh"
	warn "$HADOOP_PATH/sbin/start-dfs.sh"
	warn "$HADOOP_PATH/sbin/start-yarn.sh"
	if (( `hadoop_status` == 5 )); then
		echo "hadoop started successfully!"
	else
		echo "hadoop started failed!"
	fi
}

if [ -z "$HADOOP_PATH" ]; then
	echo "Hadoop is not installed yet"
	exit 1
fi

warn "config_hadoop"
warn "start_local_hadoop"
