metrics-watch
================================

# Introduction

By combining Logstash, Elasticsearch, Kibana (ELK) and Nginx to create an end-to-end stack for metrics collection, storing, indexing and viewing.

We have been collecting metrics from YARN (running_apps + pending_apps) and openlava cluster (running_jobs + pending_jobs). More metrics can be added easily through providing: i) a script to collect metrics and dump to a file; and ii) a logstash filter to parse the metrics. All these metrics collection aims at helping on auto-scaling among multi-tenant clusters.

## Metrics-watch environment is setup as follows:

1. node2: logstash + elasticsearch + kibana + nginx
2. node2 - node5: metrics collector

## How metrics-watch works

1. Metrics collector collects metrics data periodically and persists to files on HDFS/NFS/S3, etc. Collector on resource manager (node2) reports the metrics from YARN. Collector on openlava master host reports the metrics from openlava cluster.
2. Logstash creates a pipeline for receiving metrics data from files, processing and outputting structured data into Elasticsearch.
3. Kibana is metrics visualization engine, allowing viewing Elasticsearch's metrics via custom dashboards.
4. Nginx is the webserver for kibana.

# Getting Started

SSH into node2 and run the following command to start metrics-watch.

## Start Elasticsearch

```
/usr/local/elasticsearch/bin/elasticsearch & >/dev/null 2>&1
```

## Start Nignx

```
/usr/sbin/nginx -c /etc/nginx/nginx.conf & >/dev/null 2>&1
```

## Start metrics collector

```
/vagrant/metrics/bin/startAll.sh >/dev/null 2>&1
```

Metrics are reported every 1 minutes, and data are persisted under folder /vagrant/metrics/data.

If you want to stop metrics collector, run following command.

```
/vagrant/metrics/bin/stopAll.sh >/dev/null 2>&1
```

## Start Logstash for storing metrics with Elasticsearch

```
/usr/local/logstash/bin/logstash -f /usr/local/metrics/logstash-conf/logstash-elasticsearch.conf & >/dev/null 2>&1
```

## Query metrics from Elasticsearch

Run following command to list all the indexes.

```
curl 'localhost:9200/_cat/indices?v'
```

The Logstash created index is named like "logstash-$date" (e.g., logstash-2015.02.13). Under this index, an example search is querying all metrics related to openlava clusters.

```
curl -XPOST 'localhost:9200/logstash-2015.02.13/_search?pretty' -d '
{
  "query": { "match": { "application_type": "openlava" } }
}'
```

Refer to http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search.html for more search APIs. We support following search filed currently. More fields can be added via adding to logstash filter.

```
timestamp
host = "logstash installed host"
type = [yarn, app]
running         #yarn
pending         #yarn
application_id  #openlava
running_jobs    #openlava
pending_jobs    #openlava
```

## View metrics from Kibana 
Access Kibana dashboards at "http://node2/kibana"
