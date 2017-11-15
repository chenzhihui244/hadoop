#!/bin/sh

. $TOPDIR/scripts/env.sh

function config_hadoop
{
	grep -q "$HADOOP_DATA" $HADOOP_PATH/etc/hadoop/core-site.xml && return 0

	cp -f $TOPDIR/config/hadoop/local-core-site.xml ${HADOOP_PATH}/etc/hadoop/core-site.xml
	sed -i "s;hadoop_path;${HADOOP_DATA};g" ${HADOOP_PATH}/etc/hadoop/core-site.xml

	cp -f $TOPDIR/config/hadoop/local-hdfs-site.xml ${HADOOP_PATH}/etc/hadoop/hdfs-site.xml
	sed -i "s;hadoop_path;${HADOOP_DATA};g" ${HADOOP_PATH}/etc/hadoop/hdfs-site.xml

	cp -f $TOPDIR/config/hadoop/local-yarn-site.xml ${HADOOP_PATH}/etc/hadoop/yarn-site.xml

	cp -f $TOPDIR/config/hadoop/local-mapred-site.xml ${HADOOP_PATH}/etc/hadoop/mapred-site.xml

	sed -i "s/export.*JAVA_HOME.*=.*\${JAVA_HOME}//g" ${HADOOP_PATH}/etc/hadoop/hadoop-env.sh
	echo "export JAVA_HOME=${JAVA_HOME}" >> ${HADOOP_PATH}/etc/hadoop/hadoop-env.sh
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

function start_local_hadoop {
	if (( `hadoop_status` == 5 )); then
		echo "hadoop already started"
		return 0
	fi

	while (( `hadoop_status` != 0 )); do
		echo "stop hadoop first"
		stop_local_hadoop
	done

	warn "${HADOOP_PATH}/bin/hdfs namenode -format"
	warn "$HADOOP_PATH/sbin/start-dfs.sh"
	warn "$HADOOP_PATH/sbin/start-yarn.sh"
	if (( `hadoop_status` == 5 )); then
		echo "hadoop started successfully!"
	else
		echo "hadoop started failed!"
	fi
}

function stop_local_hadoop {
	warn "$HADOOP_PATH/sbin/stop-yarn.sh"
	warn "$HADOOP_PATH/sbin/stop-dfs.sh"
}

if [ -z "$HADOOP_PATH" ]; then
	echo "Hadoop is not installed yet"
	exit 1
fi

warn "config_hadoop"
warn "start_local_hadoop"
