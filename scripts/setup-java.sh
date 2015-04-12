#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalJava {
	echo "installing open jdk from local file"
	FILE=/vagrant/resources/$JAVA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function setupJava {
	echo "setting up java"
	ln -s /usr/local/jdk1.7.0_75 /usr/local/java
}

function setupEnvVars {
	echo "creating java environment variables"
	echo export JAVA_HOME=/usr/local/java >> /etc/profile.d/java.sh
	echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh
	chmod +x /etc/profile.d/java.sh
}

function installJava {
	installLocalJava
}

#  How to install ant and maven by http://www.unixmen.com/install-apache-ant-maven-tomcat-centos-76-5/

function installAnt {
	echo "install Ant"
    FILE=/vagrant/resources/$ANT_ARCHIVE
    if resourceExists $ANT_ARCHIVE; then
		echo "install Ant from local file"
	else
		curl -o $FILE -O -L http://mirror.sdunix.com/apache/ant/binaries/apache-ant-1.9.4-bin.zip
	fi
    unzip $FILE -d /usr/local
    ln -s /usr/local/apache-ant-1.9.4 /usr/local/ant
    ln -s /usr/local/ant/bin/ant /usr/bin/ant
}

function setupAntEnvVars {
	echo "creating Ant environment variables"
	echo \#!/bin/bash >> /etc/profile.d/ant.sh
	echo export ANT_HOME=/usr/local/ant >> /etc/profile.d/ant.sh
	echo export PATH=\${ANT_HOME}/bin:\${PATH} >> /etc/profile.d/ant.sh
	echo export CLASSPATH=. >> /etc/profile.d/ant.sh
    chmod +x /etc/profile.d/ant.sh
}

function installMaven {
	echo "install Maven"
    FILE=/vagrant/resources/$MAVEN_ARCHIVE
    if resourceExists $MAVEN_ARCHIVE; then
		echo "install Maven from local file"
	else
		curl -o $FILE -O -L http://apache.mirror.rafal.ca/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.zip
	fi
    unzip $FILE -d /usr/local
    ln -s /usr/local/apache-maven-3.2.5 /usr/local/maven
    ln -s /usr/local/maven/bin/mvn /usr/bin/mvn
}

function setupMavenEnvVars {
	echo "creating Maven environment variables"
	echo \#!/bin/bash >> /etc/profile.d/maven.sh
	echo export MAVEN_HOME=/usr/local/maven >> /etc/profile.d/maven.sh
	echo export PATH=\${MAVEN_HOME}/bin:\${PATH} >> /etc/profile.d/maven.sh
	echo export CLASSPATH=. >> /etc/profile.d/maven.sh
    chmod +x /etc/profile.d/maven.sh
}

function installrJava {
	echo "install rJava"
	FILE=/vagrant/resources/$RJAVA_ARCHIVE
	R CMD INSTALL $FILE
}

echo "setup java"
installJava
setupJava
setupEnvVars
installAnt
setupAntEnvVars
installMaven
setupMavenEnvVars
#installrJava
