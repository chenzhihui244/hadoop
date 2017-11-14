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

. $TOPDIR/install/etc/profile

cd ${TOPDIR}

echo "setup clang ..."
sh $TOPDIR/scripts/clang-build.sh

echo "setup hadoop ..."
sh ${TOPDIR}/scripts/hadoop-build.sh
