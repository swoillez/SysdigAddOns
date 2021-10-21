#/bin/sh
#
# execute with sudo
#

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker $USER
usermod -aG docker ubuntu
usermod -aG docker stephw
sysctl net.bridge.bridge-nf-call-iptables=1
apt install jq -y

# Switch the cgroup driver to systemd

cat << EOF >> /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl restart docker
