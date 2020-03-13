#!/bin/bash
#
################################################################################
#
# Script to create a Sysdig Team scoped to a NameSpace
#
################################################################################
#
# Arguments have to be provided as environment variables
#
# SYSDIG_TOKEN : API Access Token
# SYSDIG_BACKEND : URL to the Sysdig backend. Format is : "https://<URL or IP>" 
# SYSDIG_NAMESPACE : Name of the namespace
#
################################################################################
#
# The Team name will be : "Team <SYSDIG_NameSpace>"
# The Sysdig Cloud backend is https://app.sysdigcloud.com
#
# To get the JSON descriptions of Teams :
# curl -XGET -H'Authorization: Bearer $SYSDIG_TOKEN' $SYSDIG_BACKEND/api/teams
#
################################################################################

echo "createNameSpaceTeam: Check and Setup some variables"

if [ -z  "$SYSDIG_TOKEN"  ]
then
    echo "createNameSpaceTeam: ERROR, SYSDIG_TOKEN was NOT provided and is required"
    exit 1
fi

if [ -z  "$SYSDIG_NAMESPACE"  ]
then
    echo "createNameSpaceTeam: ERROR, SYSDIG_NAMESPACE was NOT provided and is required"
    exit 1
fi

if [ -z  "$SYSDIG_BACKEND"  ]
then
    echo "createNameSpaceTeam: SYSDIG_BACKEND not provided. Defaulting to Sysdig Cloud"
     SYSDIG_BACKEND="https://app.sysdigcloud.com"
fi

SYSDIG_TEAM_NAME="Team $SYSDIG_NAMESPACE"
SYSDIG_TEAM_DESCRIPTION="This team as access to the namespace $SYSDIG_NAMESPACE"
SYSDIG_FILTER="kubernetes.namespace.name = \\\"$SYSDIG_NAMESPACE\\\""

generate_createteam_data()
{
  cat <<EOF
{
  "id":null,
  "name":"$SYSDIG_TEAM_NAME",
  "description":"$SYSDIG_TEAM_DESCRIPTION",
  "show":"container",
  "theme": "#0FD4E2",
  "default":false,
  "immutable":false,
  "filter": "$SYSDIG_FILTER",
  "canUseSysdigCapture":true,
  "canUseCustomEvents":false,
  "canUseAwsMetrics":false,
  "canUseBeaconMetrics":true,
  "products":null,
  "origin":"SYSDIG",
  "entryPoint":{
     "module":"Explore"
  }
}
EOF
}

echo "createNameSpaceTeam: Using Backend at: $SYSDIG_BACKEND"
echo "createNameSpaceTeam: Using API TOKEN : $SYSDIG_TOKEN"
echo "createNameSpaceTeam: Filter: $SYSDIG_FILTER"
echo "createNameSpaceTeam: Team Name: $SYSDIG_TEAM_NAME"
echo "createNameSpaceTeam: Team Description: $SYSDIG_TEAM_DESCRIPTION"
echo "createNameSpaceTeam: Team Filter: $SYSDIG_FILTER"
echo

curl -i \
-H "Authorization: Bearer $SYSDIG_TOKEN" \
-H "Content-Type:application/json" \
-X POST --data "$(generate_createteam_data)" "$SYSDIG_BACKEND/api/teams"

echo