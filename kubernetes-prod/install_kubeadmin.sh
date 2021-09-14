#!/bin/bash

## Letting iptables see bridged traffic
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

## Install docker 
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce

# change docker cgroupdirve to systemd

sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# restart docker

sudo systemctl restart docker.service

# install kubeadmin, kubectl and kubelet
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

## Init kubeadmin (RUN IN MASTER)

#kubeadm init // uncomment in the case of the master

## join master   (RUN IN NODE)

## from node worker use kubeadm join to add node work to be part of the cluster, the command "kubeadm join ...." is the result that shows us at the end when we start the cluster with "kubeadm initi" in master node.

## To make kubectl work for your non-root user, run these commands, which are also part of the kubeadm init output:


## Use this in master (AFTER kubeadm init, UNCOMMENT THE LINE BELOW TO RUN IN MASTER)

#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Alternatively, if you are the root user, you can run:
#export KUBECONFIG=/etc/kubernetes/admin.conf

# Add node network (UNCOMMENT THE LINE BELOW TO RUN IN MASTER)
# kubectl apply -f https://docs.projectcalico.org/latest/manifests/calico.yaml


#Configure Master server to schedule pods
#kubectl taint nodes --all node-role.kubernetes.io/master-
