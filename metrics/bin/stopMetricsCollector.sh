for pid in $(ps -ef|grep metricsCollector|awk '{print $2}')
do 
	kill $pid; 
done
