#!/bin/bash

MVN_URL=http://mirrors.hust.edu.cn/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
MVN_BIN=apache-maven-3.5.2.tar.gz
MVN_DIR=${MVN_BIN%\.*}
MVN_DIR=${MVN_DIR%\.*}

MVN_PATH=$INSTALL_DIR/$MVN_DIR

function mvn_installed() {
	[ -e $MVN_PATH/bin/mvn ]
}

function mvn_config() {
	grep -q "MVN_PATH" $INSTALL_DIR/etc/profile &&
	echo "$MVN_DIR already installed" &&
	return

	echo "export MVN_PATH=$MVN_PATH" >> $INSTALL_DIR/etc/profile
	echo 'export PATH=$MVN_PATH/bin:$PATH' >> $INSTALL_DIR/etc/profile
}

function mvn_install() {
	if mvn_installed; then
		echo "$MVN_DIR alread installed"
		return
	fi

	echo "install $MVN_BIN"
	if [ ! -f $PKG_DIR/$MVN_BIN ]; then
		wget $MVN_URL -O $PKG_DIR/$MVN_BIN
	fi

	tar xf $PKG_DIR/$MVN_BIN -C $INSTALL_DIR

	mvn_config
}
