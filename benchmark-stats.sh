#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

if (( $# < 1 )); then
	echo "$0 <log file name>"
	exit 1
fi

. $TOPDIR/install/etc/profile
. $TOPDIR/scripts/stats-java-vm-flags.sh

jvm_flags_stats $1
