#!/bin/sh

HIBENCH_URL=https://github.com/intel-hadoop/HiBench.git
HIBENCH_TAG="HiBench-6.0"

HIBENCH_SRC=hibench-src-6.0.tar.gz
HIBENCH_SRC_DIR=${HIBENCH_SRC%\.*}
HIBENCH_SRC_DIR=${HIBENCH_SRC_DIR%\.*}

HIBENCH_BIN=hibench-6.0.tar.gz
HIBENCH_BIN_DIR=${HIBENCH_BIN%\.*}
HIBENCH_BIN_DIR=${HIBENCH_BIN_DIR%\.*}

. $TOPDIR/scripts/env.sh

function hibench_installed {
	#[ -e $TOPDIR/install/${HIBENCH_BIN_DIR}/bin/run_all.sh ]
	[ -e $TOPDIR/install/${HIBENCH_BIN_DIR}/bin/run-all.sh ]
}

function build_hibench {
	if [ -e $TOPDIR/pkgs/$HIBENCH_SRC ]; then
		[[ -d $TOPDIR/build/${HIBENCH_SRC_DIR} ]] || \
			tar xf $TOPDIR/pkgs/$HIBENCH_SRC -C $TOPDIR/build
	else
		git clone -b $HIBENCH_TAG $HIBENCH_URL $TOPDIR/build/${HIBENCH_SRC_DIR}
		pushd $TOPDIR/build && tar czf $TOPDIR/pkgs/$HIBENCH_SRC ${HIBENCH_SRC_DIR} && popd
	fi

	echo "build $HIBENCH_BIN ..."
	pushd $TOPDIR/build/${HIBENCH_SRC_DIR}
	warn "./bin/build-all.sh"
	popd
	mv $TOPDIR/build/${HIBENCH_SRC_DIR} $TOPDIR/install/$HIBENCH_BIN_DIR
	pushd $TOPDIR/install && tar czf $TOPDIR/pkgs/$HIBENCH_BIN $HIBENCH_BIN_DIR && popd
}

function configure_hibench {
	grep -q "HIBENCH_PATH" $TOPDIR/install/etc/profile && return 0

	echo "export HIBENCH_PATH=${TOPDIR}/install/${HIBENCH_BIN_DIR}" >> $TOPDIR/install/etc/profile
}

if hibench_installed; then
	echo "${HIBENCH_BIN} already installed!"
	exit 0
fi

if [ ! -d $TOPDIR/install/${HIBENCH_BIN_DIR} ]; then
	if [ ! -e $TOPDIR/pkgs/${HIBENCH_BIN} ]; then
		warn "build_hibench"
	fi
	tar xf ${TOPDIR}/pkgs/${HIBENCH_BIN} -C $TOPDIR/install
fi

warn "configure_hibench"
