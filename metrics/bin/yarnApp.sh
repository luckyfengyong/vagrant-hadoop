#yarn cluster running and pending apps
json_data=$(curl -s http://node2:8088/ws/v1/cluster/metrics)
appsRunning=$(echo $json_data|awk -F"," '{ print $4 }')
appsPending=$(echo $json_data|awk -F"," '{ print $3 }')
appsRunning_out=$(echo $appsRunning|awk -F":" '{ print $2 }')
appsPending_out=$(echo $appsPending|awk -F":" '{ print $2 }')
echo $appsRunning_out $appsPending_out