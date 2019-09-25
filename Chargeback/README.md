# SysdigAddOns / Chargeback

## What is Chargeback

Chargeback is the action to measure the consumption of resources, consolidate these data at various organizational levels and cost centers, and distribute them to individuals and teams for daily monitoring, and to a billing system for actual charging. A chargeback mechanism consists of two main functions:

1. A system that monitors, records and presents resources consumptions

2. A component that takes the result of the consumption monitoring system, and charge users

The Sysdig Platform allows various kinds of visibility to the Consumption metrics, including real-time dashboards, table formatted recaps, and API access for integration with billing platforms.

## What I need to implement Chargeback

In order to create a chargeback engine that feeds the billing system, one needs:

1. A component that collects various consumption metrics and aggregate them along time and organizational structures.

2. A way to associate computing elements, and its consumptions, to the organizational levels.

3. Real-time dashboards to allow people to look at their consumption, and be able to drill-down to teams and individuals.

4. Programmatic access to these date to extract them from the monitoring system and send them to the billing system.

The use of custom labels associated with containers components allows any kind of grouping to consolidate charges and still allow the drill down to individual consumptions.

## Charging metrics

Charging of infrastructure usage heavily depends on the context and the type of applications executed on the infrastructure. Basic metrics are obvious to identify:

* The more CPU you need, the larger your infrastructure needs will be. Most of the times, CPU usage is measured by cores. Containers environments often allows CPU reservation. It is thus important to keep the bigger value between reservation and actual usage.

* Memory is another obvious metric and a factor of cost. As for CPU, memory can be reserved for containers, even if it is not entirely used. The larger value between reservation and actual usage is charged to the user.

## Sysdig measures and distributes consumption

With Sysdig Platform you can easily implement a consumption measurement mechanism to fill a billing platform in order to charge your internal and external users for their usage of the containers platforms.

As Sysdig Platform supports a large spectrum of containers platforms, including on-prem and public cloud environments, almost every running environment can be on-boarded to the Sysdig Chargeback system.

## Track consumption using labels

In a containers world, it is very easy to associate compute elements to organisations and cost centers using labels that are applied everywhere. Below is an example of labels used to track consumption for organisations and cost centers:

With the standard dockerfile format:

``` dockerfile
LABEL “team”=”<My Team>”
LABEL “department”=”<My Department>”
LABEL “businessunit”=”<My Business Unit>”
LABEL “costcenter”=”<My Cost Center>”
```
With the Kubernetes format:

``` yaml
metadata:
  labels:
    team: “<My Team>“
    department: “<My Department>“
    businessunit: “<My Business Unit>“
    costcenter: “<My Cost Center>“
```

Labels are recorded by the Sysdig agents while monitoring for events. Thus they appear in the Sydig Monitor console allowing grouping and aggregation of data.

## Enforce organizational labels with Sysdig Secure

Sysdig Secure has an image scanning policy function, allowing us the creation of custom policies to validate not only security-related configurations but also corporate rules. It is then a good practice to create a specific policy to test Docker images for the existence of required labels, and maybe block the use of images that do not have these labels. The following screenshot is an example of such a validation policy:

[Policy]: https://github.com/swoillez/SysdigAddOns/tree/master/Chargeback/images/Policy-Labeling.png "Policy Labelling"


## Real-time Consumption Dashboards

Sysdig dashboards allow live visualisation of the collected consumption metrics. To get the best of them, we must first create groupings to navigate into data with paths that are meaningful to what we are looking at; then we create a dashboard to visualize the collected metrics into a synthetic graphical view.

### Grouping

The organisational labels created above are visible in Sysdig Monitor, and they can be used to create the groupings. Following are grouping examples that can be very useful to look at when building consumption reports:

* Consumption by Cost Center

```
kubernetes.deployment.label.costcenter
kubernetes.deployment.name
kubernetes.pod.name
Container.name
```

* Consumption by Organisation Tree

```
kubernetes.deployment.label.businessunit
kubernetes.deployment.label.department
kubernetes.deployment.label.team
container.label.io.kubernetes.pod.namespace
```

### Dashboards

Dashboards show data in a single panel allowing the understanding of costs, if something can be improved to lower cost, and drill down to individual containers.

There are many ways to present data, and one wants to see what matters for his/her personal role. The following dashboard has been created as an example, to show what can be assembled for consumption.

[Dashboard]: https://github.com/swoillez/SysdigAddOns/tree/master/Chargeback/images/Consumption-Dashboard.png "Consumption Dashboard"

## API Integration with a Sysdig billing backend

The consumption data gathered by the Sysdig Platform must be sent to a billing system for actual charging of cost centers, teams and users. Sysdid provides an API access to query the backend for data. This API access is available using REST, and a Python wrapper exists as well.

Using the Python access, it is very easy to build a Sysdig query, and retrieve the consumption data in JSON format. The JSON formatted data can then be sent to a billing system for immediate processing, or stored in a database for further manipulations before been sent for billing.

The Python script example provided with this article demonstrates this querying ability and displays the result on the screen. It can be easily modified to process the resulting data in a different way. The following screenshot shows the different options available to call the script, as well as an example of data query:

[API]: https://github.com/swoillez/SysdigAddOns/tree/master/Chargeback/images/Consumption-API-Access.png "API Access"

In order for this to work, you need to configure the Sysdig backend Python environment on your machine. The installation steps are provided with the Sysdig platform developer documentation that can be found at the following location:

 https://sysdigdocs.atlassian.net/wiki/spaces/Platform/pages/209059843/Developer+Documentation

## Materials

An example of Kubernetes YAML deployment with organisational labels, and the code of the Python script to query the backend are available in the GItHub Repo https://github.com/swoillez/SysdigAddOns in the Chargeback directory
