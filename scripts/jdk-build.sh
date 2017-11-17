#!/bin/sh

#JDK_BIN=java-1.8.0-openjdk-1.8.0.151-1.b12.el7_4.aarch64.tar.gz
#JDK_BIN=jdk-8u152-linux-arm64-vfp-hflt.tar.gz
JDK_BIN=java-1.8.0-openjdk-1.8.0.144-0.b01.el7_4.aarch64.tar.gz

#JDK_DIR=jdk1.8.0_152
JDK_DIR=${JDK_BIN%\.*}
JDK_DIR=${JDK_DIR%\.*}

. $TOPDIR/scripts/env.sh

JAVA_HOME=$TOPDIR/install/$JDK_DIR

echo "JAVAHOME=$JAVA_HOME"

function jdk_installed {
	java -version > /dev/null 2>&1 || return 1
	grep -q "JAVA_HOME" $TOPDIR/install/etc/profile || return 1
	return 0
}

function jdk_setup {
	echo "install $JDK_BIN into $TOPDIR/install ..."
	tar xf $TOPDIR/pkgs/$JDK_BIN -C $TOPDIR/install
}

function jdk_configure {
	grep -q "JAVA_HOME" $TOPDIR/install/etc/profile && return 0

	echo "export JAVA_HOME=$JAVA_HOME" >> $TOPDIR/install/etc/profile
	echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> $TOPDIR/install/etc/profile
	echo 'export CLASSPATH=.:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar' >> $TOPDIR/install/etc/profile
}

function jdk_install {
	jdk_installed && return 0
	jdk_setup && jdk_configure
}
