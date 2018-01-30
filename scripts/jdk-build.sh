#!/bin/sh

opt_java="pkg" # ("apt" "pkg" "rpm")

#JDK_BIN=jdk-8u152-linux-arm64-vfp-hflt.tar.gz
JDK_BIN=jdk8u-server-release-1609.tar.xz

#JDK_DIR=jdk1.8.0_152
JDK_DIR=${JDK_BIN%\.*}
JDK_DIR=${JDK_DIR%\.*}

. $TOPDIR/scripts/env.sh

JAVA_HOME=$TOPDIR/install/$JDK_DIR

function jdk_installed {
	java -version > /dev/null 2>&1 || return 1
	grep -q "JAVA_HOME" $TOPDIR/install/etc/profile || return 1
	return 0
}

function jdk_setup {
	if [ $opt_java = "rpm" ]; then
		echo "install jdk from yum repo"
		yum install -y java-1.8.0-openjdk-devel
	elif [ $opt_java = "pkg" ]; then
		echo "install $JDK_BIN into $TOPDIR/install ..."
		tar xf $TOPDIR/pkgs/$JDK_BIN -C $TOPDIR/install
	else
		echo "invalid opt_java:$opt_java"
		return 1
	fi
}

function jdk_configure {
	if [ $opt_java = "rpm" ]; then
		echo "jdk installed by yum"
		echo ". /etc/java/java.conf" >> $TOPDIR/install/etc/profile
		echo 'export JAVA_HOME=$JVM_ROOT/java' >> $TOPDIR/install/etc/profile
	elif [ $opt_java = "pkg" ]; then
		grep -q "JAVA_HOME" $TOPDIR/install/etc/profile && return 0

		echo "export JAVA_HOME=$JAVA_HOME" >> $TOPDIR/install/etc/profile
		echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> $TOPDIR/install/etc/profile
		echo 'export CLASSPATH=.:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar' >> $TOPDIR/install/etc/profile
	else
		echo "invalid opt_java:$opt_java"
		return 1
	fi
}

function jdk_install {
	jdk_installed && return 0
	jdk_setup && jdk_configure
}
