#!/bin/sh

. $TOPDIR/scripts/env.sh

function config_hadoop
{
	grep -q "$HADOOP_PATH" $HADOOP_PATH/etc/hadoop/core-site.xml && return 0

	cp $TOPDIR/config/hadoop/local-core-site.xml ${HADOOP_PATH}/etc/hadoop/core-site.xml
	sed -i "s;hadoop_path;${HADOOP_DATA};g" ${HADOOP_PATH}/etc/hadoop/core-site.xml

	cp $TOPDIR/config/hadoop/local-hdfs-site.xml ${HADOOP_PATH}/etc/hadoop/hdfs-site.xml
	sed -i "s;hadoop_path;${HADOOP_DATA};g" ${HADOOP_PATH}/etc/hadoop/hdfs-site.xml

	cp $TOPDIR/config/hadoop/local-yarn-site.xml ${HADOOP_PATH}/etc/hadoop/yarn-site.xml

	cp $TOPDIR/config/hadoop/local-mapred-site.xml ${HADOOP_PATH}/etc/hadoop/mapred-site.xml

	sed -i "s/export.*JAVA_HOME.*=.*\${JAVA_HOME}//g" ${HADOOP_PATH}/etc/hadoop/hadoop-env.sh
	echo "export JAVA_HOME=${JAVA_HOME}" >> ${HADOOP_PATH}/etc/hadoop/hadoop-env.sh
}

function start_local_hadoop {
	warn "${HADOOP_PATH}/bin/hdfs namenode -format"
	warn "$HADOOP_PATH/sbin/start-dfs.sh"
	warn "$HADOOP_PATH/sbin/start-yarn.sh"
}

function stop_local_hadoop {
	warn "$HADOOP_PATH/sbin/stop-yarn.sh"
	warn "$HADOOP_PATH/sbin/stop-dfs.sh"
}

function check_hadoop_status {
	jps | awk 'BEGIN {jps=1;namenode=1;nodemanager=1;resourcemanager=1;secondarynamenode=1;datanode=1} \
		$2 ~ "NameNode" {namenode=0} \
		$2 ~ "NodeManager" {nodemanager=0} \
		$2 ~ "ResourceManager" {resourcemanager=0} \
		$2 ~ "SecondaryNameNode" {secondarynamenode=0} \
		$2 ~ "DataNode" {datanode=0} \
		$2 ~ "Jps" {jps=0} \
		END {if ((jps==1) || (namenode==1) || (nodemanager==1) (resourcemanager==1) || (secondarynamenode==1) || (datanode==1)) printf "hadoop not running"; else print "hadoop started"}'
}

if [ -z "$HADOOP_PATH" ]; then
	echo "Hadoop is not installed yet"
	exit 1
fi

warn "config_hadoop"
warn "start_local_hadoop"
check_hadoop_status
