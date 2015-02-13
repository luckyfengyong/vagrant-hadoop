#!/bin/bash
source "/vagrant/scripts/common.sh"

#http://logstash.net/docs/1.4.2/tutorials/getting-started-with-logstash
#http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_installation.html
#http://wiki.nginx.org/Install
#http://www.elasticsearch.org/overview/kibana/installation/

function installLogstash {
	echo "install logstash"
	FILE=/vagrant/resources/$LOGSTASH_ARCHIVE
	if resourceExists $LOGSTASH_ARCHIVE; then
		echo "install logstash from local file"
	else
		curl -o $FILE -O -L $LOGSTASH_MIRROR_DOWNLOAD
	fi
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/$LOGSTASH_VERSION /usr/local/logstash
}

function installElasticsearch {
	echo "install elasticsearch"
	FILE=/vagrant/resources/$ELASTICSEARCH_ARCHIVE
	if resourceExists $ELASTICSEARCH_ARCHIVE; then
		echo "install elasticsearcg from local file"
	else
		curl -o $FILE -O -L $ELASTICSEARCH_MIRROR_DOWNLOAD
	fi
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/$ELASTICSEARCH_VERSION /usr/local/elasticsearch
}

function installNginx {
	echo "install nginx"
	cp /vagrant/resources/nginx.repo /etc/yum.repos.d/
	yum install -y nginx
}

function installKibana {
	echo "install kibana"
	FILE=/vagrant/resources/$KIBANA_ARCHIVE
	if resourceExists $KIBANA_ARCHIVE; then
		echo "install kibana from local file"
	else
		curl -o $FILE -O -L $KIBANA_MIRROR_DOWNLOAD
	fi
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/$KIBANA_VERSION /usr/share/nginx/html/kibana
}

echo "setup ELK"
installLogstash
installElasticsearch
installNginx
installKibana

