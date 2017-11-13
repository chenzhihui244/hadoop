#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)
export TOPDIR

mkdir -p ${TOPDIR}/{pkgs,build,install}

cd ${TOPDIR}

sh ${TOPDIR}/scripts/hadoop-build.sh
