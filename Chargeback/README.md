# SysdigAddOns / Chargeback

## What's in here

These files are the materials associated with building chargeback with the Sysdig platform.

The two YAML files are an example of a Kubernetes deployment modified to add labels to the deployment in order to associate the consumption of deployments to orgnisations and cost centers.

The Python file is a example of programmatic access to the Sysdig Backend to extract consumption data from Sysdig. The example displays the result of the query on the terminal, but the JSON result could also be reformated and sent to a billing system for actual charging.

## What is Chargeback ? 
Chargeback is the action to measure the consumption of resources, consolidate these data at various organizational levels and cost centers, and distribute them to individuals and teams for daily monitoring, and to a billing system for actual charging
