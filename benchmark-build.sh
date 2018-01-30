#!/bin/sh

opt_build_clang=1
opt_build_jdk=1
opt_build_mvn=1
opt_build_hadoop=1
opt_build_hibench=1

TOPDIR=$(cd `dirname $0`; pwd)
PKG_DIR=$TOPDIR/pkgs
INSTALL_DIR=$TOPDIR/install
BUILD_DIR=$TOPDIR/build

mkdir -p ${TOPDIR}/{pkgs,build,install}
mkdir -p ${TOPDIR}/install/etc

if [ ! -e ${TOPDIR}/install/etc/profile ]; then
	echo "export TOPDIR=$TOPDIR" >${TOPDIR}/install/etc/profile
	echo "export PKG_DIR=$PKG_DIR" >> $TOPDIR/install/etc/profile
	echo "export INSTLL_DIR=$INSTLL_DIR" >> $TOPDIR/install/etc/profile
	echo "export BUILD_DIR=$BUILD_DIR" >> $TOPDIR/install/etc/profile
fi

. $TOPDIR/scripts/env.sh
. $TOPDIR/scripts/clang-build.sh
. $TOPDIR/scripts/hadoop-build.sh
. $TOPDIR/scripts/hibench-build.sh
. $TOPDIR/scripts/jdk-build.sh
. $TOPDIR/scripts/maven.sh
. $TOPDIR/install/etc/profile

function build_test {
	if (( opt_build_clang )); then
		echo -e "\nsetup clang ..."
		warn "install_clang"
	fi

	if (( opt_build_jdk )); then
		echo -e "\nsetup jdk ..."
		warn "jdk_install"
	fi

	if (( opt_build_mvn )); then
		echo -e "\nsetup maven ..."
		warn "mvn_install"
	fi

	if (( opt_build_hadoop )); then
		echo -e "\nsetup hadoop ..."
		warn "install_hadoop"
	fi

	if (( opt_build_hibench )); then
		echo -e "\nsetup hibench ..."
		warn "install_hibench"
	fi
}

cd ${TOPDIR}

warn "build_test"
