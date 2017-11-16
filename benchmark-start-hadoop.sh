#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

function run_hadoop {
	echo -e "\nstart hadoop ..."
	sh $TOPDIR/scripts/hadoop-start.sh
}

. $TOPDIR/scripts/env.sh
. $TOPDIR/install/etc/profile

cd ${TOPDIR}

run_hadoop
