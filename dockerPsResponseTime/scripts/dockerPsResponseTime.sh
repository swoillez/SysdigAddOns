#!/bin/bash
#
# Stephane Woillez / swoillez@hotmail.com
#
####################
# Script Parameters
####################
#
# **CLUSTER_NAME**: Name of the cluster to monitor (it will appear in Sysdig dashboards)
# **CHECK_INTERVAL**: Time in seconds between two checks
# **DOCKER_HOST**: Docker Open Source mode:  this is the URL with port to the Docker host
# **UCP_PUBLIC_FQDN**: Docker Enterprise mode: Address of the cluster in the form "https://<name or IP address>"
# **UCP_ADMIN_USERID**: Docker Enterprise mode: Name of a user able to execute "docker ps"
# **UCP_ADMIN_PASSWORD**: Docker Enterprise mode: The password of the user account above
# **METRIC_LABELS**: (Optional) Comma-separated additional parameters. ex: region=europe, team=marketing
# **MILLISECONDS**: If set, gives the result in milliseconds, otherwise seconds
#
################
# Use local host
################
#
# To connect to a local host, you are already set
#
####################################
# Configure Remote access for Docker
####################################
#
# To connect to a remote Swarm cluster / Host, you need to reference the DOCKER_HOST variable:
# Example: export DOCKER_HOST=tcp://192.168.59.103:<port>
# Docker unencrypted socket: 2375
# Docker encrypted socket: 2376
#
#################################
# Docker Enterprise Configuration
#################################
#
# To connect to a Docker Enterprise cluster, reference the following UCP variables:
#
# UCP_PUBLIC_FQDN : UCP Public URL
# UCP_ADMIN_USERID : The UCP Admin user ID
# UCP_ADMIN_PASSWORD : Password of the UCP administrator

echo "dockerPsResponseTime: Check and Setup some variables"

if [ -z  "$CLUSTER_NAME"  ]
then
    echo "dockerPsResponseTime: ERROR, CLUSTER_NAME was NOT provided and if required"
    exit 1
fi

if [ -z  "$CHECK_INTERVAL"  ]
then
    echo "dockerPsResponseTime: Check interval no set. Default is 10sec"
    export CHECK_INTERVAL=10
fi

# If UCP_PUBLIC_FQDN is set, then we need to download the Admin client bundle to use "docker ps"
# How to programmatically access the Docker EE cluster is described here: https://docs.docker.com/ee/ucp/user-access/cli/

if [ -n  "$UCP_PUBLIC_FQDN"  ]
then
    echo "dockerPsResponseTime: Docker EE mode"

    # Retrieve and extract the Auth Token for the current user
    AUTHTOKEN=$(curl -sk -d '{"username":"'"$UCP_ADMIN_USERID"'","password":"'"$UCP_ADMIN_PASSWORD"'"}' https://$UCP_PUBLIC_FQDN/auth/login | jq -r .auth_token)
    echo "AUTH TOKEN IS : $AUTHTOKEN"

    # Download the user client bundle to extract the certificate and configure the cli for the swarm to join
    curl -k -H "Authorization: Bearer ${AUTHTOKEN}" https://$UCP_PUBLIC_FQDN/api/clientbundle -o bundle.zip

    # Unzip the bundle.
    unzip bundle.zip

    # Run the utility script.
    eval "$(<env.sh)"
else
    # Nothing to do in Swarm mode as the DOCKER_HOST variable should be already set
    echo "dockerPsResponseTime: Docker Swarm mode"
fi

# Check if we can access the docker server/cluster

echo "dockerPsResponseTime: Test if environment is accessible"

docker ps
if [ "$?" = "0" ]; then
	echo "dockerPsResponseTime: The docker environment is online"
else
	echo "dockerPsResponseTime: ERROR the docker environment is unreachable" 1>&2
	exit 1
fi

# Building Labels string

if [ -z "$METRIC_LABELS"  ]
then
    strlabels="#cluster=${CLUSTER_NAME}"
else
    strlabels="#cluster=${CLUSTER_NAME},${METRIC_LABELS}"
fi

echo "dockerPsResponseTime: Entering the probe loop"

# Format of StatD messages: METRIC_NAME#LABEL_NAME=LABEL_VALUE,LABEL_NAME:VALUE|TYPE

while true
do
    if [ -n "$MILLISECONDS"  ]
    then
        DPSTIME=$({ time docker ps ; } |& grep real | sed -E 's/[^0-9\.]+//g' | tr -d '\n' | (cat && echo " * 1000 /1 ") | bc)
    else
        DPSTIME=$({ time docker ps ; } |& grep real | sed -E 's/[^0-9\.]+//g')
    fi

# Echo the result of the test

# Examples:
# Result echoed on the console: echo "dockerPsResponseTime:${DPSTIME}|g"
# Send to the Sysdig Agent installed locally on the server: echo "dockerPsResponseTime:${DPSTIME}|g" > /dev/udp/127.0.0.1/8125
# Send to a remote Sysdig agent: echo "dockerPsResponseTime:${DPSTIME}|g" | nc -w 1 -u <IP Sysdig Agent> 8125
# Add Labels to metrics -> dockerPsResponseTime#region=‘Asia’,customer_ID=‘abc’:${DPSTIME}|g

    echo "dockerPsResponseTime${strlabels}:${DPSTIME}|g"
    echo "dockerPsResponseTime${strlabels}:${DPSTIME}|g" > /dev/udp/127.0.0.1/8125
	
	sleep $CHECK_INTERVAL # Sleeping until next test
done