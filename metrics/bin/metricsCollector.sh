while [[ 1 ]];
do
    # yarn_apps metrics:
	# num_running_app num_pending_app
    local_host=$(hostname)
	if [[ "node2" == $local_host ]];
	then
	    /usr/local/metrics/bin/yarnApp.sh >> "/vagrant/metrics/data/yarn"
	fi
	
	# openlava metrics:
	# master_host app_id num_running_job num_pending_job
	output=$(/usr/local/metrics/bin/openlavaJob.sh)
	if [ ! -z "$output" ];
	then
	    hostname=$(echo $output|awk '{ print $1 }')
	    app_metrics=$(echo $output|awk '{ print $2" "$3" "$4 }')
	    echo $app_metrics >> $"/vagrant/metrics/data/app_openlava_"$hostname
	fi
    sleep 60
done
