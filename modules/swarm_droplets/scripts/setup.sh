#!/bin/bash
INDEX=$1
MANAGER_IP=$2
PRIVATE_KEY_PATH=$3

exec > >(tee /tmp/setup.log) 2>&1

echo "[INFO] Downloading and installing docker..."
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce

echo "[INFO] Running Docker setup..."
systemctl start docker
systemctl enable docker
yum install net-tools -y
yum install vim -y