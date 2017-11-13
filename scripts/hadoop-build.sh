#!/bin/sh

#HADOOP_URL=http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-2.8.2/hadoop-2.8.2-src.tar.gz
HADOOP_URL=http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.8.2/hadoop-2.8.2-src.tar.gz

HADOOP_SRC=hadoop-2.8.2-src.tar.gz
HADOOP_SRC_DIR=${HADOOP_SRC%\.*}
HADOOP_SRC_DIR=${HADOOP_SRC_DIR%\.*}

HADOOP_BIN=hadoop-2.8.2.tar.gz
HADOOP_DIR=${HADOOP_BIN%\.*}
HADOOP_DIR=${HADOOP_DIR%\.*}

function warn {
	if ! eval "$@"; then
		echo >2 "WARNING: command ($@) failed!"
		exit 1
	fi
}

function prepare_dep {
	yum install -y gcc gcc-c++
	#ln -s /usr/lib64/libgcc_s-4.8.5-20150702.so.1 /usr/lib64/libgcc_s.so
	export LD_LIBRARY_PATH=/usr/lib/gcc/aarch64-redhat-linux/4.8.2:$LD_LIBRARY_PATH
	export LIBRARY_PATH=/usr/lib/gcc/aarch64-redhat-linux/4.8.2:$LIBRARY_PATH
	yum install -y cmake
	yum install -y maven
	yum install -y protobuf-compiler
}

function build_hadoop {
	prepare_dep

	if [ ! -d ${TOPDIR}/build/${HADOOP_SRC_DIR} ]; then
		if [ ! -e ${TOPDIR}/pkgs/${HADOOP_SRC} ]; then
			warn "wget ${HADOOP_URL} -O ${TOPDIR}/pkgs/${HADOOP_SRC}"
		fi
		warn "tar xf ${TOPDIR}/pkgs/${HADOOP_SRC} -C ${TOPDIR}/build"
	fi

	pushd ${TOPDIR}/build/${HADOOP_SRC_DIR}
	echo "Build Hadoop ..."
	warn "mvn package -Pdist,native -DskipTests -Dtar -T64"
	popd
	mv ${TOPDIR}/build/${HADOOP_SRC_DIR} ${TOPDIR}/install/{HADOOP_DIR}
	tar czf ${TOPDIR}/pkgs/${HADOOP_BIN} ${TOPDIR}/install/{HADOOP_DIR}
}

if [ ! -d ${TOPDIR}/install/${HADOOP_DIR} ]; then
	if [ ! -e ${TOPDIR}/pkgs/${HADOOP_BIN} ]; then
		build_hadoop
	fi
	tar xf ${TOPDIR}/pkgs/${HADOOP_BIN} -C ${TOPDIR}/install
fi

