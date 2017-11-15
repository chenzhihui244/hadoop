#!/bin/sh

TOPDIR=$(cd `dirname $0`; pwd)

mkdir -p ${TOPDIR}/{pkgs,build,install}
mkdir -p ${TOPDIR}/install/etc

if [ ! -e ${TOPDIR}/install/etc/profile ]; then
	echo "export TOPDIR=$TOPDIR" >${TOPDIR}/install/etc/profile
	echo "export PATH=${TOPDIR}/install/bin:${TOPDIR}/install/sbin:$PATH" >> \
		$TOPDIR/install/etc/profile
	echo "export LD_LIBRARY_PATH=${TOPDIR}/install/lib:${TOPDIR}/install/lib64:${LD_LIBRARY_PATH}" >> \
		$TOPDIR/install/etc/profile
fi

function build_test {
	echo -e "\nsetup clang ..."
	sh $TOPDIR/scripts/clang-build.sh

	echo -e "\nsetup hadoop ..."
	sh ${TOPDIR}/scripts/hadoop-build.sh

	echo -e "\nsetup hibench ..."
	sh $TOPDIR/scripts/hibench-build.sh

	echo -e "\nsetup jdk ..."
	sh $TOPDIR/scripts/jdk-build.sh
}

function run_test {
	#echo -e "\nstart hadoop ..."
	#sh $TOPDIR/scripts/hadoop-start.sh

	echo -e "\nstart hibench ..."
	sh $TOPDIR/scripts/hibench-start.sh
}

. $TOPDIR/scripts/env.sh
. $TOPDIR/install/etc/profile

cd ${TOPDIR}

#warn "build_test"
warn "run_test"
