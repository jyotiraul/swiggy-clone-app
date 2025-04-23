
# 🍔 Swiggy-Clone Application — DevSecOps Blue-Green Deployment on AWS ECS

This project demonstrates a secure, zero-downtime Blue-Green Deployment strategy for a **Swiggy-Clone Application** using **AWS ECS, CodePipeline, CodeBuild, CodeDeploy, SonarQube, and Trivy**.

---

## 🛠️ Step-by-Step Implementation

### ✅ Step 1: EC2 Setup & SonarQube

1. **Create Key Pair** in AWS for SSH access.
 ![image](https://github.com/user-attachments/assets/39bcad2b-ebbf-4d96-8b1b-8391c8b72262)


2. **Launch EC2 Instance** and open port `9000` in the security group (for SonarQube).
   ![image](https://github.com/user-attachments/assets/e670f3b3-aeb3-4cd9-814f-0d7a0e870dbe)
   ![image](https://github.com/user-attachments/assets/8dd643b8-d883-47ee-9210-e93937369ee0)


3. SSH into EC2:
   ```bash
   sudo apt update
   sudo apt install docker.io -y
   sudo usermod -aG docker ubuntu
   sudo systemctl restart docker
   docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
   ```
4. Access SonarQube at `http://<ec2-public-ip>:9000`
   ![image](https://github.com/user-attachments/assets/6f354d99-d69c-4dfe-9fc5-9e043989bb09)

5. Create a project manually -> generate a token and copy it.
![image](https://github.com/user-attachments/assets/dd4bdd45-4332-4df4-9de5-d9956ba1b67e)

![image](https://github.com/user-attachments/assets/729d26bb-98f9-4143-8297-798e396fc8c6)

---

### 🔐 Step 2: AWS Systems Manager Parameter Store

1. Store the **SonarQube token** as a secure string parameter.
  
2. Ensure the parameter name matches what's defined in your `buildspec.yml`.
![image](https://github.com/user-attachments/assets/02d82833-5b6d-453f-b6f1-289486205740)
![image](https://github.com/user-attachments/assets/15d38f11-223c-4cba-8bf7-aa5ee2c6279e)


---

### 🧱 Step 3: CodeBuild Setup

1. Create a **CodeBuild Project**.
 ![image](https://github.com/user-attachments/assets/4d7f32d4-d748-4205-ac7a-439c2e753c47)


2. Update the **CodeBuild IAM Role** with necessary permissions.
![image](https://github.com/user-attachments/assets/3ee93eb6-4b5b-480d-bdd4-6fee34af579c)
![image](https://github.com/user-attachments/assets/33f4f9ee-88da-4a47-9aae-fb26a0d4bd06)


3. Start the build to trigger **SonarQube Analysis**.
![image](https://github.com/user-attachments/assets/cae0354f-fc2e-43a2-b690-fcf184b0ce19)
![image](https://github.com/user-attachments/assets/35df5934-003e-480b-a28d-ab4f1c5e5825)


4. Use **Trivy** to scan and output reports like:
   - `trivyfilescan.txt`
   - `trivyimage.txt`
![image](https://github.com/user-attachments/assets/fee75f1e-0cc8-4d13-afe7-560889b02aa6)
![image](https://github.com/user-attachments/assets/13ddcb0e-9dd7-44a4-9cac-52a8ad7c804f)


---

### 🚀 Step 4: ECS Cluster & Load Balancer

1. Create an **ECS Cluster** (e.g., `swiggy_cluster`)
![image](https://github.com/user-attachments/assets/61a20d2b-03c1-4410-bc73-894db284321f)


2. Create a **Task Definition** with container settings.
![image](https://github.com/user-attachments/assets/4251e2ae-bc9f-4cbe-a52e-7191118ffb46)


3. Setup **Application Load Balancer** (`Swiggy-alb`) and a **Target Group**.
![image](https://github.com/user-attachments/assets/8959e0bd-2888-4843-b805-6b7cd43e2c89)
![image](https://github.com/user-attachments/assets/039039eb-45ee-4d2e-b94c-81ea2bd2e3a0)


4. Successful load balancer look like
![image](https://github.com/user-attachments/assets/f82ab91e-f898-4550-bcb0-1458109b3929)


5. Create an IAM role for **ECS CodeDeploy**.
![image](https://github.com/user-attachments/assets/b776a341-2787-4545-a1cc-e545f9531ee5)


---

### 🔄 Step 5: ECS Service Creation

1. Under the ECS Cluster, create a new Service.
![image](https://github.com/user-attachments/assets/30ad38f9-55a9-4f77-a447-ce6eda8cce93)


2. Associate the Target Group and Load Balancer.
- ![image](https://github.com/user-attachments/assets/dd6f2025-4b3b-4892-86e0-c5845d9791c1)


3 After deployment, copy the Load Balancer DNS and open it in your browser.
![image](https://github.com/user-attachments/assets/d0a844e7-f70a-4f46-8412-3cefbd615c7c)


#We can also find this application in the CodeDeploy -> Applications section
---

### 📦 Step 6: CodePipeline Integration

1. Go to **AWS CodePipeline** → Create Pipeline → Choose custom creation.
2. Configure Source (e.g., GitHub), Build (CodeBuild), and Deploy (CodeDeploy).
3. Verify successful pipeline creation.

![image](https://github.com/user-attachments/assets/94ea3912-e4e0-4b5e-85c6-f0816a1e8375)
![image](https://github.com/user-attachments/assets/90d72474-58c6-4010-b2b9-97855a1fe523)
![image](https://github.com/user-attachments/assets/a71b04d5-fd05-458b-833d-5f353a884415)

---

### 🔁 Step 7: Blue-Green Deployment

1. Edit `index.html` (e.g., update title from “Swiggy App” to “Swiggy Application”).
  ![image](https://github.com/user-attachments/assets/44692692-56da-4943-aea8-a440907f6a01)

2. Commit and push changes to GitHub.
3. CodePipeline triggers deployment.
3. Observe traffic shifting between target groups (`Tg-swiggy-svc-2` ➝ `swiggy TG1`).
![image](https://github.com/user-attachments/assets/e60c0c9c-86ee-4057-8921-956cfb53a88f)
![image](https://github.com/user-attachments/assets/682f7317-09bc-47e9-aeed-0f3e8d0f6fa0)
![image](https://github.com/user-attachments/assets/5efacb3c-720b-4a4d-8b7f-3d35974505b5)


---

### 🧹 Step 8: Clean-Up

1. Delete ECS cluster, EC2 instances, and CodePipeline setup to avoid charges.

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
GitHub: [(https://github.com/jyotiraul
)] 

---
