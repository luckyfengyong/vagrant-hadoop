#!/bin/bash
source "/vagrant/scripts/common.sh"

function installJaguar {
	echo "install Jaguar"
	FILE=/vagrant/resources/$SLIDER_ARCHIVE
	unzip $FILE -d /usr/local
    ln -s /usr/local/$SLIDER_VERSION /usr/local/slider
}

#http://www.postgresql.org/download/linux/ubuntu/
function installPostgresql {
    echo "install Postgresql"
	echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >>  /etc/apt/sources.list.d/pgdg.list
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 
	apt-get update
	apt-get install postgresql-9.4 -y
	service postgresql start 9.4
	cp -f /vagrant/resources/pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
	
	tar -xvf /vagrant/resources/jaguar-0.3.DEV.tar -C /usr/local/
	ln -s /usr/local/jaguar-0.3.DEV /usr/local/jaguar
	
	
}

function setupEnvVars {
	echo "creating slider environment variables"
	cp -f $SLIDER_RES_DIR/jaguar.sh /etc/profile.d/jaguar.sh
}

function installAppPackages {
	echo "install slider application packages"

}

echo "setup slider"
installSlider
setupSlider
setupEnvVars
installAppPackages