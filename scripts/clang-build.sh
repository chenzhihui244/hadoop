#!/bin/sh

CLANG_URL=http://releases.llvm.org/3.9.1/clang+llvm-3.9.1-aarch64-linux-gnu.tar.xz
CLANG=clang+llvm-3.9.1-aarch64-linux-gnu.tar.xz
CLANG_DIR=${CLANG%\.*}
CLANG_DIR=${CLANG_DIR%\.*}

function clang_installed {
	[ -e $TOPDIR/install/$CLANG_DIR/bin/clang ]
}

function configure_clang {
	grep -q "${CLANG_DIR}" $TOPDIR/install/etc/profile && return 0
	echo "export PATH=${TOPDIR}/install/${CLANG_DIR}/bin:$PATH" >> \
		$TOPDIR/install/etc/profile
}

function setup_clang {
	if [ ! -e $TOPDIR/pkgs/${CLANG} ]; then
		warn "wget ${CLANG_URL} -O $TOPDIR/pkgs/${CLANG}"
	fi

	tar xf $TOPDIR/pkgs/${CLANG} -C $TOPDIR/install
}

function install_clang {
	clang_installed && return 0

	setup_clang && configure_clang
}
