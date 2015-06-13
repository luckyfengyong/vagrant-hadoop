#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalJava {
	FILE=/vagrant/resources/$JAVA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function setupJava {
	echo "setting up java"
	ln -s /usr/local/jdk1.7.0_76 /usr/local/java
	ln -s /usr/local/java/bin/java /usr/bin/java
	ln -s /usr/local/java/bin/javac /usr/bin/javac
	ln -s /usr/local/java/bin/jar /usr/bin/jar
	ln -s /usr/local/java/bin/javah /usr/bin/javah
}

function setupEnvVars {
	echo "creating java environment variables"
	echo export JAVA_HOME=/usr/local/java >> /etc/profile.d/java.sh
	echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh
	chmod +x /etc/profile.d/java.sh
}

function installJava {
	if resourceExists $JAVA_ARCHIVE; then
		echo "installing open jdk from local file"
	else
		wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u76-b13/jdk-7u76-linux-x64.tar.gz" -O /vagrant/resources/$JAVA_ARCHIVE
	fi
	
	installLocalJava
}

#  How to install ant and maven by http://www.unixmen.com/install-apache-ant-maven-tomcat-centos-76-5/

function installAnt {
	echo "install Ant"
    FILE=/vagrant/resources/$ANT_ARCHIVE
    if resourceExists $ANT_ARCHIVE; then
		echo "install Ant from local file"
	else
		curl -o $FILE -O -L $ANT_MIRROR_DOWNLOAD
	fi
    unzip $FILE -d /usr/local
    ln -s /usr/local/apache-ant-1.9.5 /usr/local/ant
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
		curl -o $FILE -O -L $MAVEN_MIRROR_DOWNLOAD
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
	source /etc/profile
	FILE=/vagrant/resources/$RJAVA_ARCHIVE
	R CMD javareconf
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
installrJava
