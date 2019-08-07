#!/usr/bin/env python
#
# This script extract the consumption metrics of one cluster for le last
# hour. The result is displayed as a table, but the JSON can also be used
# to be injected into a database or directly into a billing system
#
# usage : python get_consumptions_for_costcenter.py <Sysdig API Token> <ClusterName>
#
# Every deployment gets organization details if labels have been set for it
#
# This is a Python script that use the Sysdig client. It is a wrapper of
# the Sysdig REST API. You can directly use the REST API if you prefer
#
# Prerequisite: You need to add labels to kubernetes deployments to group consumptions.
# See example below:
#
#     kind: Deployment
#     apiVersion: extensions/v1beta1
#     metadata:
#       name: labelapp-deployment
#       labels:
#         name: labelapp
#         app: labelapp
#         team: "labelapp-team"                  <<<<<<<<
#         department: "labelapp-department"      <<<<<<<<
#         businessunit: "labelapp-bu"            <<<<<<<<
#         costcenter: "32693"                    <<<<<<<<
#
# Usage examples:
#
# Get Help:
#           get_k8s_consumptions.py -h
# Print the consumption by costcenters on the entire infrastructure:
#           python get_k8s_consumptions.py <ysdig_token> -bCC
# Print the consumption for cost center 32694:
#           python get_k8s_consumptions.py $sysdig_token -f "kubernetes.deployment.label.costcenter = '32694'" -bCC

import os
import sys
import json
import datetime
import argparse
sys.path.insert(0, os.path.join(os.path.dirname(os.path.realpath(sys.argv[0])), '..'))
from sdcclient import SdcClient

#
# Parse arguments using argparse library
#
parser = argparse.ArgumentParser()
parser.add_argument("sysdigToken", help="sysdigToken>: You can find your token at https://secure.sysdig.com/#/settings/user")
parser.add_argument("-f", "--filter", help='Scope Filter. Format : "<metric>=\'<value>\'"')
parser.add_argument("-cL", "--colLength", type=int, default=20, help='Length of the table columns')
group = parser.add_mutually_exclusive_group()
group.add_argument("-bCC", "--byCostCenter", action="store_true", help="Aggregate consumptions by Cluster then CostCenter")
group.add_argument("-bCCD", "--byCostCenterDeployment", action="store_true", help="Aggregate consumptions by Cluster then CostCenter then Deployment")
group.add_argument("-bO", "--byOrg", action="store_true", help="Aggregate consumptions by Organizationnal hierarchy")
args = parser.parse_args()

#
# Retrieve the Sysdig API Token
#
sdc_token = args.sysdigToken

#
# Prepare the metrics list.
#
if args.byCostCenter:
    print("Get consumptions by cost center")
    metrics = [
    {"id": "kubernetes.cluster.name"},
    {"id": "kubernetes.deployment.label.costcenter"},
    {"id": "cpu.cores.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.pod.resourceRequests.cpuCores", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "memory.bytes.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.pod.resourceRequests.memBytes", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "fs.bytes.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.persistentvolumeclaim.storage", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "net.bytes.in", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "net.bytes.out","aggregations": { "time": "avg", "group": "sum"}}
    ]
elif args.byCostCenterDeployment:
    print("Get consumptions by cost center and split by deployment")
    metrics = [
    {"id": "kubernetes.cluster.name"},
    {"id": "kubernetes.deployment.label.costcenter"},
    {"id": "kubernetes.deployment.name"},
    {"id": "cpu.cores.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.pod.resourceRequests.cpuCores", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "memory.bytes.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.pod.resourceRequests.memBytes", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "fs.bytes.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.persistentvolumeclaim.storage", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "net.bytes.in", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "net.bytes.out","aggregations": { "time": "avg", "group": "sum"}}
    ]
elif args.byOrg:
    print("Get consumptions by organisationnal hierarchy")
    metrics = [
    {"id": "kubernetes.deployment.label.businessunit"},
    {"id": "kubernetes.deployment.label.department"},
    {"id": "kubernetes.deployment.label.team"},
    {"id": "container.label.io.kubernetes.pod.namespace"},
    {"id": "kubernetes.deployment.name"},
    {"id": "kubernetes.pod.name"},
    {"id": "container.name"},
    {"id": "cpu.cores.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.pod.resourceRequests.cpuCores", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "memory.bytes.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.pod.resourceRequests.memBytes", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "fs.bytes.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.persistentvolumeclaim.storage", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "net.bytes.in", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "net.bytes.out","aggregations": { "time": "avg", "group": "sum"}}
    ]
else: # default is by costCenter
    print("Default behavior is to get consumptions by cost center")
    metrics = [
    {"id": "kubernetes.cluster.name"},
    {"id": "kubernetes.deployment.label.costcenter"},
    {"id": "cpu.cores.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.pod.resourceRequests.cpuCores", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "memory.bytes.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.pod.resourceRequests.memBytes", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "fs.bytes.used", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "kubernetes.persistentvolumeclaim.storage", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "net.bytes.in", "aggregations": { "time": "avg", "group": "sum"}},
    {"id": "net.bytes.out","aggregations": { "time": "avg", "group": "sum"}}
    ]

#
# Instantiate the SDC client
#
sdclient = SdcClient(sdc_token)

#
# Fire the query.
#
ok, res = sdclient.get_data(metrics=metrics,               # List of metrics to query
                            filter=args.filter,            # The filter specifying the target host
                            start_ts=-3600,                # Start of query span is an hour ago
#                            start_ts=-144000,                # Start of query span is a day ago
                            end_ts=0)                      # End the query span now

#
# Show the result
#
if ok:

    #
    # The JSON looks like this:
    #
    # {
    #     start: timestamp,
    #     end: timestamp,
    #     data: [
    #         {
    #             t: timestamp,
    #             d: [ value1, value2, value3, ... ]
    #         },
    #         ...
    #     ]
    # }
    #

    #
    # Print summary (what, when)
    #
    start = res['start']
    end = res['end']
    data = res['data']

    displaystart = datetime.datetime.fromtimestamp(start).strftime('%Y-%m-%d %H:%M:%S')
    displayend = datetime.datetime.fromtimestamp(end).strftime('%Y-%m-%d %H:%M:%S')

    print('Data for %s from %s to %s' % (args.filter if args.filter else 'everything', displaystart, displayend))
    print('')

    #
    # Print table headers
    #
    dataToPrint = ' '.join([str(x['id']).ljust(args.colLength) if len(str(x['id'])) < args.colLength else str(x['id'])[:(args.colLength - 3)].ljust(args.colLength - 3) + '...' for x in metrics])
    print('%s' % dataToPrint)
    print('')

    #
    # Print table body
    #
    for d in data:
        values = d['d']

        dataToPrint = ' '.join([str(x).ljust(args.colLength) if len(str(x)) < args.colLength else str(x)[:(args.colLength - 3)].ljust(args.colLength - 3) + '...' for x in values])
        print('%s' % dataToPrint)

else:
    print(res)
    sys.exit(1)