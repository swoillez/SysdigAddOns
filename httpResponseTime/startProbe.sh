#!/bin/bash

echo "-- Build the container image"

docker build . -t stephw/http-response-time

echo "-- Set Variables"

#  WEBSITE_URL="http://www.google.com"
WEBSITE_URL="http://www.microsoft.com"
METRIC_NAME="websiteResponseTime"
# export METRIC_LABELS="region=us"
CHECK_INTERVAL=10

echo "-- Launch the container"

docker run -d \
-e WEBSITE_URL=${WEBSITE_URL} -e METRIC_NAME=${METRIC_NAME} -e METRIC_LABELS=${METRIC_LABELS} -e CHECK_INTERVAL=${CHECK_INTERVAL} \
stephw/http-response-time