#!/bin/bash
openssl req -newkey rsa:2048 -nodes -keyout serverkey.pem -x509 -days 365 -out server.pem
mkdir /var/docker
cp ./server.pem /var/docker/server.pem
cp ./serverkey.pem /var/docker/serverkey.pem
mkdir /etc/systemd/system/docker.service.d
cp ./startup_options.conf /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker.service