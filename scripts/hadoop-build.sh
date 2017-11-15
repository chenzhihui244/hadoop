#!/bin/sh

HADOOP_URL=http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.8.2/hadoop-2.8.2-src.tar.gz

HADOOP_SRC=hadoop-2.8.2-src.tar.gz
HADOOP_SRC_DIR=${HADOOP_SRC%\.*}
HADOOP_SRC_DIR=${HADOOP_SRC_DIR%\.*}

HADOOP_BIN=hadoop-2.8.2.tar.gz
HADOOP_DIR=${HADOOP_BIN%\.*}
HADOOP_DIR=${HADOOP_DIR%\.*}

#set -x

. $TOPDIR/scripts/env.sh

function hadoop_installed {
	[ -e $TOPDIR/install/${HADOOP_DIR}/bin/hadoop ]
}

function prepare_hadoop_dep {
	yum install -y gcc gcc-c++
	yum install -y subversion
	yum install -y openssl-devel
	yum install -y cmake
	yum install -y maven
	yum install -y protobuf-compiler
}

function build_hadoop {
	prepare_hadoop_dep

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
grep -q "HADOOP_PATH" $TOPDIR/install/etc/profile && return 0

echo "export HADOOP_PATH=${TOPDIR}/install/${HADOOP_DIR}" >> $TOPDIR/install/etc/profile
echo 'export PATH=${HADOOP_PATH}/bin:${HADOOP_PATH}/sbin:${PATH}' >> $TOPDIR/install/etc/profile
echo "export HADOOP_DATA=${TOPDIR}/data/${HADOOP_DIR}" >> $TOPDIR/install/etc/profile
echo 'export HADOOP_MAPRED_HOME=${HADOOP_PATH}' >> $TOPDIR/install/etc/profile
echo 'export HADOOP_COMMON_HOME=${HADOOP_PATH}' >> $TOPDIR/install/etc/profile
echo 'export HADOOP_HDFS_HOME=${HADOOP_PATH}' >> $TOPDIR/install/etc/profile
echo 'export YARN_HOME=${HADOOP_PATH}' >> $TOPDIR/install/etc/profile
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PATH}/lib/native' >> $TOPDIR/install/etc/profile
echo 'export HADOOP_OPTS="-Djava.library.path=${HADDOP_INSTALL}/lib:${HADOOP_PATH}/lib/native"' >> $TOPDIR/install/etc/profile
}

if hadoop_installed; then
	echo "$HADOOP_BIN already installed!"
	exit 0
fi

if [ ! -d ${TOPDIR}/install/${HADOOP_DIR} ]; then
	if [ ! -e ${TOPDIR}/pkgs/${HADOOP_BIN} ]; then
		build_hadoop
	fi
	tar xf ${TOPDIR}/pkgs/${HADOOP_BIN} -C ${TOPDIR}/install
fi

warn "configure_hadoop"
