vagrant-hadoop-2.6.0
================================

# Introduction

Vagrant project to spin up a cluster of 6 virtual machines with Hadoop v2.6.0, Zookeeper v3.4.6, Spark v1.3.0, SparkR and Slider 0.60.0 incubating (with application packages of hbase v1.0.0 and OpenLava v2.2). Java/Ant/Maven/Scala/R/Docker environment is setup in all the nodes.

1. node1 : HDFS NameNode 
2. node2 : YARN ResourceManager + JobHistoryServer + ProxyServer + Zookeeper Server + Slider + Spark + SparkR (+ optional HBase Master)
3. node3 : HDFS DataNode + YARN NodeManager (+ optional HBase RegionServer)
4. node4 : HDFS DataNode + YARN NodeManager (+ optional HBase RegionServer)
5. node5 : HDFS DataNode + YARN NodeManager (+ optional HBase RegionServer)
6. node6 : HDFS DataNode + YARN NodeManager (+ optional HBase RegionServer)

# Getting Started

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Run ```vagrant box add ubuntu https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box```
4. Git clone this project, and change directory (cd) into this project (directory).
5. Run ```vagrant up``` to create the VM.
6. Run ```vagrant ssh``` to get into your VM. The VM name in vagrant is node1, node2 ... noden. While the ip of VMs depends on the scale of your Yarn cluster. If it is less then 10, the IP will be 10.211.55.101, .... 10.211.55.10n. Or you could run ```ssh``` directly with ip of VMs and username/password of demo/demo, and then execute "su - root" with password of vagrant.
7. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.
8. The directory of /vagrant is mounted in each VM by vagrant if you want to access host machine from VM. You could also use win-sshfs if you want to access the local file system of VM from host machine. Please refer to http://code.google.com/p/win-sshfs/ for details.

Some gotcha's.

* Make sure you download Vagrant v1.7.1 or higher and VirtualBox 4.3.20 or higher with extension package
* Make sure when you clone this project, you preserve the Unix/OSX end-of-line (EOL) characters. The scripts will fail with Windows EOL characters. If you are using Windows, please make sure the following configuration is configured in your .gitconfig file which is located in your home directory ("C:\Users\yourname" in Win7 and after, and "C:\Documents and Settings\yourname" in WinXP). Refer to http://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration for details of git configuration.
```
[core]
    autocrlf = false
    safecrlf = true
```
* Make sure you have 10Gb of free memory for the VMs. You may change the Vagrantfile to specify smaller memory requirements.
* This project has NOT been tested with the other providers such as VMware for Vagrant.
* You may change the script (common.sh) to point to a different location for Hadoop, Zookeeper .... to be downloaded from. 

# Advanced Stuff

If you have the resources (CPU + Disk Space + Memory), you may modify Vagrantfile to have even more HDFS DataNodes, YARN NodeManagers, and Spark slaves. Just find the line that says "numNodes = 6" in Vagrantfile and increase that number. The scripts should dynamically provision the additional slaves for you.

# Make the VMs setup faster
You can make the VM setup even faster if you pre-download the Hadoop ... and Oracle JDK into the /resources directory.

* /resources/hadoop-2.6.0.tar.gz
* /resources/jdk-7u75-linux-x64.tar.gz
* ....

The setup script will automatically detect if these files (with precisely the same names) exist and use them instead. If you are using slightly different versions, you will have to modify the script accordingly.

# Post Provisioning
After you have provisioned the cluster, you need to run some commands to initialize your Hadoop cluster. SSH into node1 and run the following command.

```
$HADOOP_PREFIX/bin/hdfs namenode -format myhadoop
```

## Start Hadoop Daemons (HDFS + YARN)
SSH with username/password of root/vagrant into node1 and run the following commands to start HDFS.

```
$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
$HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
```

SSH into node2 and run the following commands to start YARN.

```
$HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
$HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager
$HADOOP_YARN_HOME/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF_DIR
$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
```

### Test YARN
Run the following command to make sure you can run a MapReduce job.

```
yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar pi 2 100
```

Run the following command to make sure you can run the YRAN distributedshell example.

```
hadoop org.apache.hadoop.yarn.applications.distributedshell.Client -jar /usr/local/hadoop/share/hadoop/yarn/hadoop-yarn-applications-distributedshell-2.6.0.jar -shell_command "sleep 100000" -num_containers 10 -timeout 200000000
```

## Start Zookeeper

SSH into node2 and run the following command to start Zookeeper.

```
zkServer.sh start
```

### Test Zookeeper
Run the following command to make sure you can connect Zookeeper. Refer to http://zookeeper.apache.org/doc/r3.4.6/zookeeperStarted.html for more details

```
zkCli.sh -server node2:2181
```

Or Run following command to send command to Zookeeper. Refer to https://zookeeper.apache.org/doc/r3.4.6/zookeeperAdmin.html#sc_zkCommands for more details

```
echo ruok | nc node2 2181
```

## Verify Slider

SSH into node2 and run the following commands to create a sample application to verify Slider. Refer to http://slider.incubator.apache.org/docs/manpage.html for more details about Slider.

```
slider install-package --name MEMCACHED --package $SLIDER_PREFIX/app-packages/memcached/jmemcached-1.0.0.zip
slider create memcached --template $SLIDER_PREFIX/app-packages/memcached/appConfig-memcached.json --resources $SLIDER_PREFIX/app-packages/memcached/resources-memcached.json
```

After that, run the following command to get where the memcached instance is running and the listening port allocated to memcached instance

```
slider registry --name memcached --getexp servers
```

And then run the following command to test memcached, replace the ${memcached_host} by the ip address of host on which memcached instance is running and replace ${memcached_port} by the allocated listening port. Refer to http://www.kutukupret.com/2011/05/05/memcached-in-a-shell-using-nc-and-echo/ for more commands to test memcached.

```
echo -e 'stats\r' | nc ${memcached_host} ${memcached_port}
```

After verify, run the following commands to stop and destroy sample application.

```
slider stop memcached
slider destroy memcached
```

Refer to http://slider.incubator.apache.org/docs/troubleshooting.html for troubleshooting of slider

## Start HBase (If choose to install HBase on HDFS directly)

SSH into node2 and run the following commands to start HBase cluster.

```
start-hbase.sh
```

Access HBase GUI at http://10.211.55.102:60010/master-status to verify HBase cluster

## Create HBase Cluster by Slider

SSH into node2 and run the following commands to create HBase cluster.

```
slider install-package --name HBASE --package $SLIDER_PREFIX/app-packages/hbase/slider-hbase-app-package-0.60.0-incubating.zip
slider create hbase --template $SLIDER_PREFIX/app-packages/hbase/appConfig-hbase.json --resources $SLIDER_PREFIX/app-packages/hbase/resources-hbase.json
```

### Test HBASE

Run the following command to check the status of hbase cluster.

```
slider status hbase
```

Run following command and find URL of hbase GUI by the value of "org.apache.slider.monitor". 

```
slider registry --name hbase --getexp quicklinks
```

Run the following commands to make sure you can create hbase table. Refer to http://wiki.apache.org/hadoop/Hbase/Shell for more hbase shell commands

```
hbase shell
hbase(main):001:0> list
hbase(main):002:0> create 'test','column1'
hbase(main):001:0> list
```

## Create Openlava Cluster by Slider

SSH into node2 and run the following commands to create Openlava cluster.

####Create a parent znode for openlava clusters in Zookeeper.

```
echo "create /openlava parent_znode" | zkCli.sh -server node2:2181
```

####Create openlava Cluster by Slider.

```
slider install-package --name OPENLAVA --package $SLIDER_PREFIX/app-packages/openlava/openlava-2.2.zip
slider create openlava --template $SLIDER_PREFIX/app-packages/openlava/appConfig-openlava.json --resources $SLIDER_PREFIX/app-packages/openlava/resources-openlava.json
```

####Verify openlava

Refer to http://www.openlava.org/ for how OpenLava works

####Exported Data

Check exported openlava master host and mbd port.

```
slider registry --name openlava --getexp servers
```

## Run SparkR on YARN

SSH into node2 and run the following commands.

Launch SparkR in yarn-client mode.

```
sparkR $SPARKR_HOME/examples/pi.R yarn-client
MASTER=yarn-client sparkR
```

Use following environment to configure Spark on Yarn.

```
SPARK_MASTER_MEMORY
SPARK_DRIVER_MEMORY
SPARK_WORKER_INSTANCES
SPARK_EXECUTOR_INSTANCES
SPARK_WORKER_MEMORY
SPARK_EXECUTOR_MEMORY
SPARK_WORKER_CORES
SPARK_EXECUTOR_CORES
SPARK_YARN_QUEUE
SPARK_YARN_APP_NAME
```

For example

```
MASTER=yarn-client SPARK_WORKER_INSTANCES=4 sparkR
```

# Trouble-shooting YARN

In YARN terminology, executors and application masters run inside "containers". YARN has two modes for handling container logs after an application has completed. If log aggregation is turned on (with the yarn.log-aggregation-enable config), container logs are copied to HDFS and deleted on the local machine. These logs can be viewed from anywhere on the cluster with the ```yarn logs``` command.

```
yarn logs -applicationId <app ID>
```

will print out the contents of all log files from all containers from the given application.

When log aggregation isn’t turned on, logs are retained locally on each machine under YARN_APP_LOGS_DIR, which is usually configured to /tmp/logs or $HADOOP_HOME/logs/userlogs depending on the Hadoop version and installation. Viewing logs for a container requires going to the host that contains them and looking in this directory. Subdirectories organize log files by application ID and container ID.

To review per-container launch environment, increase yarn.nodemanager.delete.debug-delay-sec to a large value (e.g. 36000), and then access the application cache through yarn.nodemanager.local-dirs (by default /tmp/hadoop-root/nm-local-dir/usercache/root/appcache) on the nodes on which containers are launched. This directory contains the launch script, JARs, and all environment variables used for launching each container. This process is useful for debugging classpath problems in particular. (Note that enabling this requires admin privileges on cluster settings and a restart of all node managers. Thus, this is not applicable to hosted clusters).

# Web UI
You can check the following URLs to monitor the Hadoop daemons.

1. [NameNode] (http://10.211.55.101:50070/dfshealth.html)
2. [ResourceManager] (http://10.211.55.102:8088/cluster)
3. [JobHistory] (http://10.211.55.102:19888/jobhistory)

# Vagrant boxes
A list of available Vagrant boxes is shown at http://www.vagrantbox.es. 

# Vagrant box location
The Vagrant box is downloaded to the ~/.vagrant.d/boxes directory. On Windows, this is C:/Users/{your-username}/.vagrant.d/boxes.

# Copyright Stuff
Copyright 2015

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
