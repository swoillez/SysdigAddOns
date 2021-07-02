# SysdigAddOns / Sysdig Secure Agent Consumption

## What this is about

Understand what are the Sysdig Secure components deployed on clusters, and what is their consdumption

## In summary

the requests put in the Kubernetes deployment files for the agent components are "safe averages" of what is seen in production across the deployments of our customers.

## The Sysdig Secure agent components

- The Sysdig agent itself, executing main tasks as well as intrusion detection
- The Node analyzer, executing local scans, node scanning, and CIS benchmarks
- The Admission Controller, validating execution of containers and monitoring the Kubernetes audit log


## The deployments of components

- One Sysdig agent per node
- One Node Analyzer per node
- One admission controller per cluster

## The consumption of the components

These numbers are compiled using real customer usage. They are "safe average", so you can use them without issue. Based on your real usage, you may lower these numbers if you think your implementation actually consumes less than the average.

### Sysdig Agent

```yaml
  requests:
    cpu: 600m
    memory: 512Mi
  limits:
    cpu: 2000m
    memory: 1536Mi
```

### Node Analyzer:

```yaml
  requests:
    cpu: 150m
     memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
```

### Admission Controller:

```yaml
    requests:
      cpu: 250m
      memory: 256Mi
    limits:
      cpu: 250m
      memory: 256Mi
```

## What happens if limits are reached

The Sysdig components are managed like any other process in Kubernetes, thus:

*CPU is a compressible resource, which means that once your container reaches the limit, it will keep running but the operating system will throttle it and keep de-scheduling from using the CPU. Memory, on the other hand, is none compressible resource. Once your container reaches the memory limit, it will be terminated, aka OOM (Out of Memory) killed. If your container keeps OOM killed, Kubernetes will report that it is in a crash loop.*