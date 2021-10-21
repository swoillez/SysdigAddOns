# SysdigAddOns / Secure Sandbox on Debian/Ubuntu

## What this is about

A couple of simple files to quickly spin up a single node Kubernetes cluster to create a sandbox for Sysdig Secure.

---

## Docker Engine installation

Download the [docker-installation.sh](./docker-installation.sh) script on your Debian/Ubuntu box. Then `chmod 755` it to make it executable. Run it with sudo. Logoff/login to reload your environment. Check the installation with `docker version`

## Configuration

Download the [k8s-installation.sh](./k8s-installation.sh) script on your Debian/Ubuntu box. Then `chmod 755` it to make it executable. Run it as root (not sudo).

---