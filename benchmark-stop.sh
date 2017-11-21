#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

. $TOPDIR/scripts/env.sh
. $TOPDIR/scripts/hadoop-start.sh
. $TOPDIR/install/etc/profile

stop_local_hadoop
