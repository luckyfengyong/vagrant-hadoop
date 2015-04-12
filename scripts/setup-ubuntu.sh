#!/bin/bash
source "/vagrant/scripts/common.sh"

function disableFirewall {
	echo "disabling firewall"
	/sbin/iptables-save
	ufw disable
}

function installUtilities {
	echo "install utilities"

	# run docker command inside docker http://www.therightcode.net/run-docker-into-a-container-on-a-mac/
	# install docker in ubuntu http://docs.docker.com/installation/ubuntulinux/
	# install R in ubuntu http://cran.r-project.org/bin/linux/ubuntu/README
	apt-get update -y
	apt-get install -y curl zip r-base r-base-dev
	curl -sSL https://get.docker.com/ubuntu/ | sh

}
echo "setup ubuntu"

disableFirewall
installUtilities