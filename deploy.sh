#!/bin/bash

set -e

echo "Updating packages..."
sudo apt update -y

echo "Installing Docker..."
sudo apt install docker.io -y

echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Stopping old container if it exists..."
sudo docker stop nextread || true
sudo docker rm nextread || true

echo "Removing old image if it exists..."
sudo docker rmi nextread-app || true

echo "Building Docker image..."
sudo docker build -t nextread-app .

echo "Running Docker container..."
sudo docker run -d -p 80:80 --name nextread nextread-app

echo "Deployment successful!"