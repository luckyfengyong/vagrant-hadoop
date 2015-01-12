#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalHBase {
	echo "install hbase from local file"
	FILE=/vagrant/resources/$HBASE_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteHBase {
	echo "install hbase from remote file"
	curl -o /vagrant/resources/$HBASE_ARCHIVE -O -L $HBASE_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$HBASE_ARCHIVE -C /usr/local
}

function setupHBase {
	echo "creating habase directories"
	mkdir /var/hbase
	
	echo "copying over hbase configuration files"
	cp -f $HBASE_RES_DIR/* $HBASE_CONF
}

function setupEnvVars {
	echo "creating habase environment variables"
	cp -f $HBASE_RES_DIR/hbase.sh /etc/profile.d/hbase.sh
}

function installHBase {
	if resourceExists $HBASE_ARCHIVE; then
		installLocalHBase
	else
		installRemoteHBase
	fi
	ln -s /usr/local/$HBASE_VERSION /usr/local/hbase
    mkdir /usr/local/hbase/hadooplibbackup
	mv /usr/local/hbase/lib/hadoop* /usr/local/hbase/hadooplibbackup/
    cp /usr/local/hadoop/share/hadoop/yarn/hadoop-yarn-api-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/yarn/hadoop-yarn-client-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/yarn/hadoop-yarn-common-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/yarn/hadoop-yarn-server-common-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/yarn/hadoop-yarn-server-nodemanager-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-shuffle-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-common-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-app-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop/share/hadoop/hdfs/hadoop-hdfs-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop-2.6.0/share/hadoop/common/lib/hadoop-auth-2.6.0.jar /usr/local/hbase/lib/
    cp /usr/local/hadoop-2.6.0/share/hadoop/mapreduce/lib/hadoop-annotations-2.6.0.jar /usr/local/hbase/lib/
    cp /vagrant/resources/hadoop-client-2.6.0.jar /usr/local/hbase/lib/
}


echo "setup hbase"
installHBase
setupHBase
setupEnvVars