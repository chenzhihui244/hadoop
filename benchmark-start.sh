#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

. $TOPDIR/scripts/env.sh
. $TOPDIR/scripts/hibench-start.sh
. $TOPDIR/install/etc/profile

function run_test {
	if ! grep -q "HIBENCH_PATH" $TOPDIR/install/etc/profile; then
		echo "hibench not installed"
		exit 1
	fi

	echo -e "\nstart hibench ..."
	warn "system_configure"
	warn "hibench_configure"
	warn "run_hibench"
	#warn "run_hibench_all"
	warn "system_restore"
}

cd ${TOPDIR}

warn "run_test"
