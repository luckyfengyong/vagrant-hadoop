#!/bin/bash
# http://stackoverflow.com/questions/6348902/how-can-i-add-numbers-in-a-bash-script
source "/vagrant/scripts/common.sh"
START=3
TOTAL_NODES=2

while getopts s:t: option
do
	case "${option}"
	in
		s) START=${OPTARG};;
		t) TOTAL_NODES=${OPTARG};;
	esac
done

function setupSlaves {
	echo "modifying $HBASE_CONF/regionservers"
	for i in $(seq $START $TOTAL_NODES)
	do 
		entry="node${i}"
		echo "adding ${entry}"
		echo "${entry}" >> $HBASE_CONF/regionservers
	done
}

echo "setup hbase slaves"
setupSlaves