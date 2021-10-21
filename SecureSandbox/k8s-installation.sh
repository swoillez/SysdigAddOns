#/bin/sh
#
# Execute when logged as root
#

swapoff -a

apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# 

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl get all --all-namespaces

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
