#!/bin/sh

. $TOPDIR/scripts/env.sh

function jdk_installed {
	java -version > /dev/null 2>&1 && return 0 || return 1
}

JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.151-1.b12.el7_4.aarch64/jre
function jdk_configure {
	grep -q "JAVA_HOME" $TOPDIR/install/etc/profile && return 0

	echo "export JAVA_HOME=$JAVA_HOME" >> $TOPDIR/install/etc/profile
	echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> $TOPDIR/install/etc/profile
	echo 'export CLASSPATH=.:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar' >> $TOPDIR/install/etc/profile
}

if jdk_installed; then
	echo "jdk already installed"
	exit
fi

warn "jdk_configure"
