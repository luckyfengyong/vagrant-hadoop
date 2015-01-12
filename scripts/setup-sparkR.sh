#!/bin/bash
source "/vagrant/scripts/common.sh"

function setupEnvVars {
	echo "creating sparkr environment variables"
	cp -f $SPARKR_RES_DIR/sparkr.sh /etc/profile.d/sparkr.sh
}

function installSparkR {
	echo "build and install sparkR from local file"
	FILE=/vagrant/resources/$SPARKR_ARCHIVE
	unzip $FILE -d /usr/local
}

echo "setup sparkR"
installSparkR
setupEnvVars
