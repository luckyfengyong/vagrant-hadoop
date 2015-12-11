#!/bin/bash
source "/vagrant/scripts/common.sh"

#http://scala-lang.org/download/install.html

function setupEnvVars {
	echo "creating scala environment variables"
	cp -f $SCALA_RES_DIR/scala.sh /etc/profile.d/scala.sh
}

function installScala {
	echo "install scala"
	FILE=/vagrant/resources/$SCALA_ARCHIVE
	if resourceExists $SCALA_ARCHIVE; then
		echo "install scale from local file"
	else
		curl -o $FILE -O -L $SCALA_MIRROR_DOWNLOAD
	fi
	tar -xzf $FILE -C /usr/lib
	ln -s /usr/lib/$SCALA_VERSION /usr/lib/scala

	# install sbt http://www.scala-sbt.org/release/tutorial/Installing-sbt-on-Linux.html
	echo "deb http://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
    apt-get update -y
    apt-get install -y sbt
}

echo "setup scala"
installScala
setupEnvVars