#!/bin/bash

#(1) This script installs Maven, Git, Nexus Repository Manager, SonarQube, and AWS CLI v2 on a Linux system.
set -e

#(2) Update package list and install required packages
sudo apt update -y

#(3) Install Docker, Git, Curl, Unzip, and Maven
sudo apt install -y docker.io git curl unzip maven

#(4) Enable and start Docker service
sudo systemctl enable --now docker

#(5) Run Nexus Repository Manager in a Docker container
sudo docker run -d -p 8081:8081 --name nexus-server sonatype/nexus3

#(6) Run SonarQube in a Docker container
sudo docker run -d -p 9000:9000 --name sonar-server sonarqube:lts-community

#(7) Install AWS CLI v2
cd /tmp
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -oq awscliv2.zip
sudo ./aws/install --update
rm -rf awscliv2.zip aws

#(8) Verify installations
git --version
mvn -version
aws --version