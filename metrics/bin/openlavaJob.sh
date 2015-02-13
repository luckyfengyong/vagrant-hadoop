#openlava cluster is running on localhost
lim_path=$(ps -ef|grep "lim"|grep "openlava"|awk '{ print $8 }')
app_id=$(echo $lim_path|awk -F"/" '{ print $8 }')
if [ ! -z "$lim_path" ];
then
  sbin_path=$(dirname $lim_path)
  bin_path="$sbin_path/../bin"
  source $bin_path/../etc/openlava.sh
  master_host=$($bin_path/lsid|grep master|awk '{ print $5 }')
  local_host=$(hostname)
  #only master host report pending jobs
  if [[ $master_host == $local_host ]];
  then
    run_jobs=$($bin_path/bqueues|tail -n+2|awk '{ print $10 }')
    pend_jobs=$($bin_path/bqueues|tail -n+2|awk '{ print $9 }')
	echo $local_host $app_id $run_jobs $pend_jobs
  fi
fi
