# Environment and deploy file
# For use with bin/server_deploy, bin/server_package etc.
DEPLOY_HOSTS="node2"

APP_USER=root
APP_GROUP=root
# optional SSH Key to login to deploy server
#SSH_KEY=/path/to/keyfile.pem
INSTALL_DIR=/usr/local/spark/job-server
LOG_DIR=/var/log/job-server
PIDFILE=spark-jobserver.pid
JOBSERVER_MEMORY=1G
SPARK_VERSION=1.4.1
SPARK_HOME=/usr/local/spark
SPARK_CONF_DIR=$SPARK_HOME/conf
# Only needed for Mesos deploys
# SPARK_EXECUTOR_URI=/usr/local/spark/spark-0.8.0.tar.gz
# Only needed for YARN running outside of the cluster
# You will need to COPY these files from your cluster to the remote machine
# Normally these are kept on the cluster in /etc/hadoop/conf
YARN_CONF_DIR=/usr/local/hadoop/etc/hadoop
SCALA_VERSION=2.11.6
