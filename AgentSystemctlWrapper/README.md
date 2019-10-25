# SysdigAddOns / AgentSystemctlWrapper

## Where do you need a systemctl wrapper for the Sysdig agent ?

- On non clustered Docker servers
- On Docker Swarm clusters

## Why using such a Wrapper ?

There is no notion of daemonset on non clustered Docker servers. You have to deploy the agent with a '```docker run```' command.

On Docker Swarm, even though there is a notion of daemonset called service with global mode, Swarm does not allow privilegied containers, and the Sysdig Agent is a privilegied container. In that case, again, you have to deploy the agent with a '```docker run```' command.

## What is the systemctl wrapper for the Sysdig agent ?

The systemctl wrapper for the Sysdig agent is a way to automate the start and restart of the sysdig agent, using the ```docker run``` command and systemctl to execute it.

Systemctl also detect the loss of the Sysdig Agent container, and restarts it automatically.

## How to use the Wrapper?

1) Create the service description

- On Ubuntu : copy this content to ```/lib/systemd/system/sysdigagent.service```

- On other Linuxes: copy this content to ```/var/systemd/system/sysdigagent.service```

2) Modify the parameters in the sysdigagent.service file

- **ACCESS_KEY**: Your Sysdig Access Key
- **TAGS**: Additionnal tags you want to add to the Docker engine
- **SECURE**: true if you enable secure on the agent
- **CHECK_CERTIFICATE**: true if you want the agent to valide the sysdig backend certificate, false if you use self signed certificates

3) Install and manage the service

- To enable the service: ```sudo systemctl enable --now sysdigagent.service```
- To stop the service: ```sudo systemctl stop sysdigagent.service```
- To start the service: ```sudo systemctl start sysdigagent.service```
- To disable the service: ```sudo systemctl disable sysdigagent.service```

## Reference

https://suda.pl/privileged-containers-in-swarm/
