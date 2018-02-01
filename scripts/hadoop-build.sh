#!/bin/sh

HADOOP_URL=http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.8.2/hadoop-2.8.2-src.tar.gz
HADOOP_VERSION="2.8.2"
HADOOP_SRC=hadoop-${HADOOP_VERSION}-src.tar.gz
HADOOP_BIN=hadoop-${HADOOP_VERSION}.tar.gz

HADOOP_SRC_DIR=${HADOOP_SRC%\.*}
HADOOP_SRC_DIR=${HADOOP_SRC_DIR%\.*}

HADOOP_DIR=${HADOOP_BIN%\.*}
HADOOP_DIR=${HADOOP_DIR%\.*}

function hadoop_installed {
	[ -e $TOPDIR/install/${HADOOP_DIR}/bin/hadoop ]
}

function prepare_hadoop {
	yum install -y gcc gcc-c++ > /dev/null
	yum install -y subversion > /dev/null
	yum install -y openssl-devel > /dev/null
	yum install -y cmake > /dev/null
	#yum install -y maven > /dev/null
	yum install -y protobuf-c > /dev/null
}

function build_hadoop {
	prepare_hadoop

	if [ ! -d ${TOPDIR}/build/${HADOOP_SRC_DIR} ]; then
		if [ ! -e ${TOPDIR}/pkgs/${HADOOP_SRC} ]; then
			warn "wget ${HADOOP_URL} -O ${TOPDIR}/pkgs/${HADOOP_SRC}"
		fi
		warn "tar xf ${TOPDIR}/pkgs/${HADOOP_SRC} -C ${TOPDIR}/build"
	fi

	pushd ${TOPDIR}/build/${HADOOP_SRC_DIR}
	echo "Build Hadoop ..."
	warn "mvn package -Pdist,native -DskipTests -Dtar -e"
	popd
	mv ${TOPDIR}/build/${HADOOP_SRC_DIR}/hadoop-dist/target/${HADOOP_BIN} ${TOPDIR}/pkgs
}

function configure_hadoop {
grep -q "HADOOP_HOME" $TOPDIR/install/etc/profile && return 0

echo "export HADOOP_HOME=${TOPDIR}/install/${HADOOP_DIR}" >> $TOPDIR/install/etc/profile
echo 'export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}' >> $TOPDIR/install/etc/profile
echo "export HADOOP_DATA=${TOPDIR}/install/data/${HADOOP_DIR}" >> $TOPDIR/install/etc/profile
echo 'export HADOOP_MAPRED_HOME=${HADOOP_HOME}' >> $TOPDIR/install/etc/profile
echo 'export HADOOP_COMMON_HOME=${HADOOP_HOME}' >> $TOPDIR/install/etc/profile
echo 'export HADOOP_HDFS_HOME=${HADOOP_HOME}' >> $TOPDIR/install/etc/profile
echo 'export YARN_HOME=${HADOOP_HOME}' >> $TOPDIR/install/etc/profile
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native' >> $TOPDIR/install/etc/profile
echo 'export HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib:${HADOOP_HOME}/lib/native"' >> $TOPDIR/install/etc/profile
echo 'export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native' >> $TOPDIR/install/etc/profile 
}

function install_hadoop {
	hadoop_installed && 
	echo "hadoop already installed" &&
	return 0

	if [ ! -d ${TOPDIR}/install/${HADOOP_DIR} ]; then
		if [ ! -e ${TOPDIR}/pkgs/${HADOOP_BIN} ]; then
			build_hadoop
		fi
		tar xf ${TOPDIR}/pkgs/${HADOOP_BIN} -C ${TOPDIR}/install
	fi

	warn "configure_hadoop"
}
