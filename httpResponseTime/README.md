# SysdigAddOns / http Response Time Probe for Sysdig

## What is the http Reponse Time Probe for Sysdig ?

This is a small piece of code that allows you to monitor the response time of WebSites, by doing a simple HTTP request on the website and generate a StatD metric with according labels.

The Sysdig agent collects automatically this StatD metric, allowing the creation of dashboards like this:
    
![Dashboard](images/dashboard.png)

## How it is built ?

The probe is a simple piece of Python code, that tests the URL, and pushes the result on the 8125 localhost UDP port. There is no need to care about sending the data to the Sysdig agent (because of the StatD teleport function of the Sysdig agent)

## What is the systemctl wrapper for the Sysdig agent ?

The systemctl wrapper for the Sysdig agent is a way to automate the start and restart of the sysdig agent, using the ```docker run``` command and systemctl to execute it.

Systemctl also detect the loss of the Sysdig Agent container, and restarts it automatically.

## How to use the Wrapper?

1) **Create the service description**

- On Ubuntu : copy the sysdigagent.service file to ```/lib/systemd/system/sysdigagent.service```

- On other Linuxes: copy the sysdigagent.service file to ```/var/systemd/system/sysdigagent.service```

2) **Modify the parameters in the sysdigagent.service file**

- **ACCESS_KEY**: Your Sysdig Access Key
- **TAGS**: Additionnal tags you want to add to the Docker engine
- **SECURE**: true if you enable secure on the agent
- **CHECK_CERTIFICATE**: true if you want the agent to valide the sysdig backend certificate, false if you use self signed certificates

3) **Install and manage the service**

- To enable the service: ```sudo systemctl enable --now sysdigagent.service```
- To stop the service: ```sudo systemctl stop sysdigagent.service```
- To start the service: ```sudo systemctl start sysdigagent.service```
- To disable the service: ```sudo systemctl disable sysdigagent.service```

## Reference

https://suda.pl/privileged-containers-in-swarm/
