#!/bin/bash

sudo apt update -y
sudo apt install docker.io -y

sudo systemctl start docker
sudo systemctl enable docker

sudo docker stop nextread || true
sudo docker rm nextread || true

sudo docker build -t nextread-app .
sudo docker run -d -p 80:80 --name nextread nextread-app