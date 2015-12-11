#!/bin/bash
source "/vagrant/scripts/common.sh"

function setupEnvVars {
	echo "creating spark environment variables"
	cp -f $SPARK_RES_DIR/spark.sh /etc/profile.d/spark.sh
}

function installSpark {
	echo "install spark"
	FILE=/vagrant/resources/$SPARK_ARCHIVE
    if resourceExists $SPARK_ARCHIVE; then
		echo "install spark from local file"
	else
        curl -o $FILE -O -L $SPARK_MIRROR_DOWNLOAD
	fi
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/$SPARK_VERSION /usr/local/spark
	
	# install job-server. Section of "Deployment" in https://github.com/spark-jobserver/spark-jobserver
	# 1. Copy config/local.sh.template to <environment>.sh and edit as appropriate.
    # 2. bin/server_deploy.sh <environment> -- this packages the job server along with config files and pushes it to the remotes you have configured in <environment>.sh
    # 3. On the remote server, start it in the deployed directory with server_start.sh and stop it with server_stop.sh

    if resourceExists v0.5.2.tar.gz; then
		echo "install job-server from local file"
	else
        curl -o /vagrant/resources/v0.5.2.tar.gz -O -L https://github.com/spark-jobserver/spark-jobserver/archive/v0.5.2.tar.gz
	fi
	gunzip /vagrant/resources/v0.5.2.tar.gz
	tar -xzf /vagrant/resources/v0.5.2.tar -C /usr/local
	ln -s /usr/local/spark-jobserver-0.5.2 /usr/local/spark-jobserver
	cp -f $SPARK_RES_DIR/local.sh /usr/local/spark-jobserver/config/
	/usr/local/spark-jobserver/bin/server_deploy.sh local
}

echo "setup spark"
installSpark
setupEnvVars