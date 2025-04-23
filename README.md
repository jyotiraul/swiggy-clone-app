
# 🍔 Swiggy-Clone Application — DevSecOps Blue-Green Deployment on AWS ECS

This project demonstrates a secure, zero-downtime Blue-Green Deployment strategy for a **Swiggy-Clone Application** using **AWS ECS, CodePipeline, CodeBuild, CodeDeploy, SonarQube, and Trivy**.

---

## 🛠️ Step-by-Step Implementation

### ✅ Step 1: EC2 Setup & SonarQube

1. **Create Key Pair** in AWS for SSH access.
 ![image](https://github.com/user-attachments/assets/20ec39da-40e4-4254-8dd5-82d08c84c30a)

3. **Launch EC2 Instance** and open port `9000` in the security group (for SonarQube).
4. SSH into EC2:
   ```bash
   sudo apt update
   sudo apt install docker.io -y
   sudo usermod -aG docker ubuntu
   sudo systemctl restart docker
   docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
   ```
5. Access SonarQube at `http://<ec2-public-ip>:9000`
6. Create a project manually -> generate a token and copy it.

---

### 🔐 Step 2: AWS Systems Manager Parameter Store

- Store the **SonarQube token** as a secure string parameter.
- Ensure the parameter name matches what's defined in your `buildspec.yml`.

---

### 🧱 Step 3: CodeBuild Setup

1. Create a **CodeBuild Project**.
2. Update the **CodeBuild IAM Role** with necessary permissions.
3. Start the build to trigger **SonarQube Analysis**.
4. Use **Trivy** to scan and output reports like:
   - `trivyfilescan.txt`
   - `trivyimage.txt`

---

### 🚀 Step 4: ECS Cluster & Load Balancer

1. Create an **ECS Cluster** (e.g., `swiggy_cluster`)
2. Create a **Task Definition** with container settings.
3. Setup **Application Load Balancer** (`Swiggy-alb`) and a **Target Group**.
4. Register your ECS service with the load balancer.
5. Create an IAM role for **ECS CodeDeploy**.

---

### 🔄 Step 5: ECS Service Creation

- Under the ECS Cluster, create a new Service.
- Associate the Target Group and Load Balancer.
- After deployment, copy the Load Balancer DNS and open it in your browser.

---

### 📦 Step 6: CodePipeline Integration

1. Go to **AWS CodePipeline** → Create Pipeline → Choose custom creation.
2. Configure Source (e.g., GitHub), Build (CodeBuild), and Deploy (CodeDeploy).
3. Verify successful pipeline creation.

---

### 🔁 Step 7: Blue-Green Deployment

- Edit `index.html` (e.g., update title from “Swiggy App” to “Swiggy Application”).
- Commit and push changes to GitHub.
- CodePipeline triggers deployment.
- Observe traffic shifting between target groups (`Tg-swiggy-svc-2` ➝ `swiggy TG1`).

---

### 🧹 Step 8: Clean-Up

- Delete ECS cluster, EC2 instances, and CodePipeline setup to avoid charges.

---

## 📷 Screenshot Highlights

> _(You can insert pipeline screenshots or application UI here)_

---

## 🧰 Tools Used

- AWS EC2, ECS, CodePipeline, CodeBuild, CodeDeploy
- SonarQube for Code Quality
- Trivy for Security Scanning
- Docker
- Node.js App (Swiggy Clone)

---

## 📝 Author

**Jyoti Raul**  
DevSecOps Enthusiast | Java Backend Developer | MSc IT  
GitHub: [@jyoti-raul](https://github.com/DevOps-Institute-Mumbai)

---
