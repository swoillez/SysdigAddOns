# Sysdig Metrics and Applications Support (As of November 2019)

## Standard Metrics

By default Sysdig agents collect the following metrics:

- System
- Process
- Network
- Kubernetes
- JVM
- Host
- File System
- Files
- AWS
- Containers
- Compliance (from Sysdig Secure)
- Applications (see next section)

Detailed Metrics are available here: https://docs.sysdig.com/en/metrics-dictionary.html

## Supported Applications

The following applications are supported out of the box by Sysdig:

- Apache
- Kafka
- Consul
- Couchbase
- Elasticsearch
- ETCD
- Fluentd
- Go
- HAProxy
- HTTP
- Jenkins
- Lighttpd
- MemcacheD
- Mesos/Marathon
- MongoDB
- MySql
- NGINX & NGINX Plus
- NTP
- PGBouncer
- PHP-FPM
- PostGreSQL
- RabbitMQ
- RedisDB
- Supervisord
- TCP
- Varnish

Detailed metrics for each application can be found here: https://docs.sysdig.com/en/applications.html


## External Metrics

In addition to standard metrics, Sysdig agents can be configured to integrate metrics:
JMX Metrics from Java Virtual Machines

- StatsD Metrics
- Log Files
- Prometheus Metrics (See below)
- Custom App and Container based Custom checks (See below)

## Custom Apps Checks

Custom Apps Checks allows the monitoring of custom apps using:

- Prometheus (See below)
- JMX
- StatsD
- A custom code developed in Python

The description of the Python code is located here: https://docs.sysdig.com/en/create-a-custom-app-check.html

## Prometheus Metrics

The Prometheus integration allows Sysdig agents to collect metrics from Prometheus exporters

The documentation for the Sysdig integration with prometheus exporters can be found here: https://docs.sysdig.com/en/integrate-prometheus-metrics.html

Today, Sysdig supports the integration with local exporters on supported Linux distributions. So, among the following list, all exporters that run on Linux and for which the exporter container runs on the same host than the Linux host, will work 

https://github.com/prometheus/prometheus/wiki/Default-port-allocations

Sysdig will add support of remote scrapping of Prometheus exporters in Q2/Q3 2020
