#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

function run_test {
	echo -e "\nstart hibench ..."
	sh $TOPDIR/scripts/hibench-start.sh
}

. $TOPDIR/scripts/env.sh
. $TOPDIR/install/etc/profile

cd ${TOPDIR}

warn "run_test"
