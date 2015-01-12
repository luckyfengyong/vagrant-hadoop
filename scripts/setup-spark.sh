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
}

echo "setup spark"
installSpark
setupEnvVars