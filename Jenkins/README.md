# SysdigAddOns / Jenkins Monitoring with Sysdig using Prometheus

## What this is about

Jenkins Prometheus Metrics


<br>

# 1) Install jenkins using Helm for testing purpose

For testing purpose, you need to have Jenkins installed and configured. An easy way to do so is to use Helm. You will need to modify the Jenkins configuration before installation. We will use the Jenkins Helm chart located here: https://github.com/helm/charts/tree/master/stable/jenkins. To access this chart, add the **stable** Helm charts repo and check that you see Jenkins in the list:

```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm search repo stable
```
<br>

## Customize the Jenkins options before installation

Before installing the chart, we need to modify the Jenkins configuration, to add/modify a few things :

1) Add an executor to the Jenkins master en allow the master to execute pipelines
2) Add the Prometheus plugin to the list of Jenkins plugins to install.
3) Add pod annotations to allow the Sysdig Agent to detect the Jenkins Prometheus plugin
4) Deactivate persistence

In order to do these configuration change, you need to download the jenkins `values.yaml`config file from here: https://raw.githubusercontent.com/helm/charts/master/stable/jenkins/values.yaml. Modify its name to `jenkins-values.yaml` so that you cannot mismatch it with the values.yaml for the Sysdig Agent.

<br>

## Modifications

### 1) Search for `numExecutors` and modify that parameter to 1

### 2) Search for `installPlugins`and add the following line to the list: `- prometheus:2.0.6`

Note that version 2.0.6 may not be the latest version of the Prometheus plugin today, so check the latest version number here: https://plugins.jenkins.io/prometheus/

### 3) Search for `podAnnotations` and add the following 3 lines between the curly brackets:

```yaml
  prometheus.io/scrape: "true",
  prometheus.io/port: "8080",
  prometheus.io/path: "/prometheus"
```

### 4) Search for `persistence` and modify the `enabled` parameter one line below to `false`

If you prefer to get an already modified `values.yaml` file, you can download it from here: <<<>>>

<br>

## Install Jenkins

Simply create a new namespace named "jenkins" and then deploy in that namespace the Jenkins chart using the customized configuration file:

```
kubectl create ns jenkins
helm install jenkins -f jenkins-values.yaml stable/jenkins -n jenkins
```

<br>

## Validate and access Jenkins

- You should be able to validate that jenkins has correctly started using:

```
kubectl get all -n jenkins
```

- To get the Jenkins admin password:

```
printf $(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
```

- To access Jenkins using kubectl port forwarding: 

```
kubectl port-forward service/jenkins 8080:8080 -n jenkins
```

Then using your favorite browser, navigate to:

 `http://localhost:8080`

![JenkinsAccess](images/jenkins-access.png)

- To validate the Jenkins Prometheus metrics, enable kubectl port forwarding as above and navigate to:

 `http://localhost:8080/prometheus`

![JenkinsPrometheus](images/jenkins-prometheus.png)

<br>


# 2) Install & Configure the Sysdig Agent

We will use Helm as well to install and Configure the Sysdig Agent. For that you will need to:

- Get your Sysdig Subscription Access Key
- Download and modify the Helm configuration for the Sysdig agent
- Install the Sysdig agent using the modifyed configuration

## Get your Sysdig Access Key

In the Sysdig console, go to `Settings/Agent Installation` and copy the Access Key:

![Sysdig Access Key](images/sysdig-access-key.png)

## Customize the Sysdig agent options before installation

The helm chart for the Sysdig agent is located here: https://github.com/helm/charts/tree/master/stable/sysdig

Download the values.yaml file to modify it. It is here: https://raw.githubusercontent.com/helm/charts/master/stable/sysdig/values.yaml

### 1) Access Key

Search for `accessKey` and paste your Sysdig access Key

```yaml
  accessKey: "<Your Sysdig Access Key>"
```

### 2) Cluster Name



Jenkins Shedule: H/5 * * * *




helm install sysdig-agent -f sysdig-values.yaml stable/sysdig -n sysdig-agent
promraw.default_jenkins


kubectl edit configmap sysdig-agent -n sysdig-agent

- Config Prometheus:

```yaml
    prometheus:
      enabled: true
      ingest_raw: true
      ingest_calculated: false
    use_promscrape: false
    10s_flush_enable: true
```


---

## Links

https://plugins.jenkins.io/prometheus/


https://sysdig.atlassian.net/wiki/spaces/~877077671/pages/865731144/Monitor+Jenkins+with+Prometheus



Metrics

### Jenkins Infrastructure

default_jenkins_up (Not Available)
promraw.default_jenkins_uptime (Not Available)
jenkins_plugins_failed
jenkins_plugins_withUpdate
jenkins_plugins_active

jenkins_health_check_score
promraw.jenkins_health_check_count

jenkins_executor_in_use_value
jenkins_executor_in_use_history
jenkins_executor_count_value
jenkins_executor_count_history
jenkins_executor_free_value

jenkins_node_offline_history
jenkins_node_online_history
jenkins_node_offline
jenkins_node_count_value
jenkins_node_count_history

jenkins_runs_total_total
jenkins_runs_success

### Jenkins ???

jenkins_job_count_value
jenkins_job_waiting_duration
jenkins_job_total_duration
jenkins_job_building_duration
jenkins_job_blocked_duration
jenkins_job_queuing_duration
jenkins_job_averageDepth
jenkins_job_scheduled_total
jenkins_job_execution_time


jenkins_queue_blocked_value
jenkins_queue_size_history
jenkins_queue_pending_history
jenkins_queue_stuck_history
jenkins_queue_size_value

jenkins_task_scheduled
jenkins_task_waiting_duration
jenkins_task_blocked_duration


## Jenkins Build Service

jenkins_project_count_value
jenkins_project_count_history
jenkins_project_enabled_count
jenkins_project_disabled_coun


default_jenkins_builds_duration_milliseconds_summary_count{jenkins_job="FailingPipeline",repo="NA",} 3975.0
default_jenkins_builds_success_build_count
default_jenkins_builds_failed_build_count
default_jenkins_builds_last_build_result
default_jenkins_builds_last_build_duration_milliseconds

Jauges

default_jenkins_builds_last_build_result
default_jenkins_builds_last_build_duration_milliseconds
jenkins_job_count_value
jenkins_plugins_failed
jenkins_queue_blocked_value