#!/bin/bash

echo "-- Build the container image"

docker build -f Dockerfile-Alpine -t stephw/dockerps-response-time:alpine .

echo "-- Create the necessary environment ariables"

CLUSTER_NAME="mycluster" # Name of the cluster to monitor
CHECK_INTERVAL=10 # Check interval in seconds
MILLISECONDS="true" # To get an output in milliseconds

# To connect to a remote docker host, set the following variable:
#
DOCKER_HOST="tcp://my.docker.cluster.com:2376"
#
# To connect to a Docker Enterprise cluster, set the following UCP variables:
#
# UCP_PUBLIC_FQDN : UCP Public URL
# UCP_ADMIN_USERID : The UCP Admin user ID
# UCP_ADMIN_PASSWORD : Password of the UCP administrator

# Manage container name

echo "-- Give a name to the container"
CONTAINER_NAME="dockerps_"$CLUSTER_NAME

echo "-- Try to stop existing same container"
docker stop $CONTAINER_NAME

echo "-- Try to clean existing same container"
docker rm $CONTAINER_NAME

# It's time to start the container

echo "-- Launch the container"

docker run -d --name $CONTAINER_NAME \
-e DOCKER_HOST=${DOCKER_HOST} -e CLUSTER_NAME=${CLUSTER_NAME} \
-e CHECK_INTERVAL=${CHECK_INTERVAL} -e METRIC_LABELS=${METRIC_LABELS} \
-e MILLISECONDS=${MILLISECONDS} \
stephw/dockerps-response-time:alpine