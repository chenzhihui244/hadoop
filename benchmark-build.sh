#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

mkdir -p ${TOPDIR}/{pkgs,build,install}
mkdir -p ${TOPDIR}/install/etc

if [ ! -e ${TOPDIR}/install/etc/profile ]; then
	echo "export TOPDIR=$TOPDIR" >${TOPDIR}/install/etc/profile
fi

. $TOPDIR/scripts/env.sh
. $TOPDIR/scripts/clang-build.sh
. $TOPDIR/scripts/hadoop-build.sh
. $TOPDIR/scripts/hibench-build.sh
. $TOPDIR/scripts/jdk-build.sh
. $TOPDIR/install/etc/profile

function build_test {
	echo -e "\nsetup clang ..."
	warn "install_clang"

	echo -e "\nsetup hadoop ..."
	warn "install_hadoop"

	echo -e "\nsetup hibench ..."
	warn "install_hibench"

	echo -e "\nsetup jdk ..."
	warn "jdk_install"
}

cd ${TOPDIR}

warn "build_test"
