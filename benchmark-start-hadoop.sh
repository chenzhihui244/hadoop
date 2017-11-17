#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

. $TOPDIR/scripts/env.sh
. $TOPDIR/scripts/hadoop-start.sh
. $TOPDIR/install/etc/profile

function run_hadoop {
	if [ -z "$HADOOP_PATH" ]; then
		echo "Hadoop is not installed yet"
		exit 1
	fi

	echo -e "\nstart hadoop ..."
	warn "config_hadoop" &&
	warn "start_local_hadoop"
}

cd ${TOPDIR}

run_hadoop
