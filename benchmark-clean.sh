#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

. $TOPDIR/scripts/env.sh

rm -rf $TOPDIR/build
rm -rf $TOPDIR/install
