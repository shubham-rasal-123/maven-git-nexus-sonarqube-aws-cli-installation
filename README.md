# 🧰 Maven, Git, Nexus, SonarQube & AWS CLI Installation on AWS EC2

A simple, automated Bash script to set up a full **DevOps toolchain** — **Maven**, **Git**, **Nexus Repository Manager**, **SonarQube**, and **AWS CLI v2** — on an **AWS EC2** instance, with Nexus and SonarQube running as Docker containers.

![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white)
![AWS](https://img.shields.io/badge/Cloud-AWS%20EC2-FF9900?logo=amazonaws&logoColor=white)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker&logoColor=white)
![Maven](https://img.shields.io/badge/Build-Maven-C71A36?logo=apachemaven&logoColor=white)
![SonarQube](https://img.shields.io/badge/Code%20Quality-SonarQube-4E9BCD?logo=sonarqube&logoColor=white)
![Nexus](https://img.shields.io/badge/Artifact-Nexus-1F5EAD?logo=sonatype&logoColor=white)
![Platform](https://img.shields.io/badge/OS-Debian%2FUbuntu-orange?logo=ubuntu)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

---

## 📋 Overview

This repository contains a shell script that provisions a single **AWS EC2** instance as a CI/CD support server — installing build and version-control tools directly on the host (Maven, Git, AWS CLI) while running **Nexus Repository Manager** and **SonarQube** as Docker containers, so you get an artifact repository and a code-quality scanner up and running in minutes.

---

## ✨ What the Script Does

| Step | Action |
|------|--------|

| 1️⃣ | Enables strict mode (`set -e`) so the script exits on any error |
| 2️⃣ | Updates the system package index |
| 3️⃣ | Installs `docker.io`, `git`, `curl`, `unzip`, and `maven` |
| 4️⃣ | Enables and starts the Docker service |
| 5️⃣ | Runs **Nexus Repository Manager** in a Docker container (port `8081`) |
| 6️⃣ | Runs **SonarQube** in a Docker container (port `9000`) |
| 7️⃣ | Downloads, installs, and cleans up after installing **AWS CLI v2** |
| 8️⃣ | Verifies `git`, `mvn`, and `aws` installations |

---

## 🛠️ Prerequisites

- An AWS account with permission to launch EC2 instances
- An EC2 instance running Ubuntu/Debian — **`c7i-flex.large` or larger recommended** (Nexus and SonarQube are memory-hungry; SonarQube alone needs ~2 GB+ RAM)
- A Security Group allowing the following inbound ports:

  | Port | Purpose |
  |------|---------|

  | 22   | SSH access |
  | 8081 | Nexus Repository Manager UI |
  | 9000 | SonarQube UI |

- A key pair (`.pem`) to SSH into the instance
- `sudo` privileges on the instance
- Outbound internet access to reach Docker Hub and `awscli.amazonaws.com`

---

## ☁️ Step 1: Launch the EC2 Instance

1. Go to **AWS Console → EC2 → Launch Instance**
2. Choose an **Ubuntu Server LTS** AMI
3. Select an instance type (`c7i-flex.large` or higher is recommended for running Nexus + SonarQube together)
4. Configure the **Security Group** to allow inbound traffic on ports **22**, **8081**, and **9000**
5. Select or create a key pair for SSH access
6. Launch the instance

---

## 🔑 Step 2: Connect to the Instance

```bash
chmod 400 your-key.pem
ssh -i "your-key.pem" ubuntu@<your-ec2-public-ip>
```

---

## 📦 Step 3: Run the Installation Script

Clone the repository and run the script on your EC2 instance:

```bash
git clone https://github.com/shubham-rasal-123/maven-git-nexus-sonarqube-aws-cli.git
cd maven-git-nexus-sonarqube-aws-cli
chmod +x install.sh
./install.sh
```

> ⚠️ Since the script uses `docker` commands, you may need to run it with `sudo` or add your user to the `docker` group first and re-login before running it.

---

## ✅ Step 4: Verify the Installation

Check the tool versions:

```bash
git --version
mvn -version
aws --version
```

Confirm both containers are running:

```bash
sudo docker ps
```

Access the web UIs using your instance's **public IP**:

```text
Nexus:      http://<your-ec2-public-ip>:8081
SonarQube:  http://<your-ec2-public-ip>:9000
```

**Default login credentials:**

| Tool | Username | Password |
|------|----------|----------|

| Nexus | `admin` | Found in the container at `/nexus-data/admin.password` (see below) |
| SonarQube | `admin` | `admin` (you'll be prompted to change it on first login) |

Retrieve the initial Nexus admin password:

```bash
sudo docker exec -it nexus-server cat /nexus-data/admin.password
```

---

---

## 📁 Repository Structure

```text
maven-git-nexus-sonarqube-aws-cli/
├── install.sh    # Main installation script
├── README.md       # Project documentation
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open a pull request or an issue.

---

## ⚠️ Notes

- Restrict the **Security Group** inbound rules for ports `22`, `8081`, and `9000` to your own IP where possible, rather than leaving them open to `0.0.0.0/0`.
- Nexus and SonarQube store data inside their containers by default in this script — data will be **lost if the containers are removed**. For persistent storage, mount Docker volumes (e.g. `-v nexus-data:/nexus-data`, `-v sonarqube_data:/opt/sonarqube/data`).
- SonarQube requires certain kernel settings (`vm.max_map_count`) to start reliably — if it fails to launch, run: `sudo sysctl -w vm.max_map_count=262144`.
- Remember to **stop or terminate** the EC2 instance when not in use to avoid unnecessary AWS charges.

---
