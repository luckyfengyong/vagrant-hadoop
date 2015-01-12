#!/bin/bash
source "/vagrant/scripts/common.sh"

#http://zookeeper.apache.org/doc/r3.4.6/zookeeperStarted.html

function installLocalZookeeper {
	echo "install zookeeper from local file"
	FILE=/vagrant/resources/$ZOOKEEPER_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteZookeeper {
	echo "install zookeeper from remote file"
	curl -o /vagrant/resources/$ZOOKEEPER_ARCHIVE -O -L $ZOOKEEPER_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$ZOOKEEPER_ARCHIVE -C /usr/local
}

function setupZookeeper {
	echo "copying over zookeeper configuration files"
	cp -f $ZOOKEEPER_RES_DIR/* $ZOOKEEPER_CONF
}

function setupEnvVars {
	echo "creating zookeeper environment variables"
	cp -f $ZOOKEEPER_RES_DIR/zookeeper.sh /etc/profile.d/zookeeper.sh
}

function installZookeeper {
	if resourceExists $ZOOKEEPER_ARCHIVE; then
		installLocalZookeeper
	else
		installRemoteZookeeper
	fi
	ln -s /usr/local/$ZOOKEEPER_VERSION /usr/local/zookeeper
}


echo "setup zookeeper"
installZookeeper
setupZookeeper
setupEnvVars