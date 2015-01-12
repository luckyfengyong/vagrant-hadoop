#!/bin/bash
source "/vagrant/scripts/common.sh"

function installSlider {
	echo "install slider from local file"
	FILE=/vagrant/resources/$SLIDER_ARCHIVE
	unzip $FILE -d /usr/local
    ln -s /usr/local/$SLIDER_VERSION /usr/local/slider
}

function setupSlider {
    echo "copying over slider configuration files"
	cp -f $SLIDER_RES_DIR/* $SLIDER_CONF
}

function setupEnvVars {
	echo "creating slider environment variables"
	cp -f $SLIDER_RES_DIR/slider.sh /etc/profile.d/slider.sh
}

function installAppPackages {
	echo "install slider application packages"
    mkdir /usr/local/slider/app-packages
    mkdir /usr/local/slider/app-packages/hbase
	FILE=/vagrant/resources/$SLIDER_HBASE_ARCHIVE
	cp $FILE /usr/local/slider/app-packages/hbase
    cp /vagrant/resources/resources-hbase.json /usr/local/slider/app-packages/hbase
    cp /vagrant/resources/appConfig-hbase.json /usr/local/slider/app-packages/hbase
    mkdir /usr/local/slider/app-packages/memcached
	FILE=/vagrant/resources/$SLIDER_MEMCACHED_ARCHIVE
	cp $FILE /usr/local/slider/app-packages/memcached
    cp /vagrant/resources/resources-memcached.json /usr/local/slider/app-packages/memcached
    cp /vagrant/resources/appConfig-memcached.json /usr/local/slider/app-packages/memcached
    mkdir /usr/local/slider/app-packages/openlava
	FILE=/vagrant/resources/$SLIDER_OPENLAVA_ARCHIVE
    cp $FILE /usr/local/slider/app-packages/openlava
    cp /vagrant/resources/resources-openlava.json /usr/local/slider/app-packages/openlava
    cp /vagrant/resources/appConfig-openlava.json /usr/local/slider/app-packages/openlava
}

echo "setup slider"
installSlider
setupSlider
setupEnvVars
installAppPackages