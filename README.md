# Kaleb Castillo's Cloud Portfolio/Blog 🚀

This is my Cloud Portfolio/Blog project. It's a static Astro website with a serverless AWS backend featuring dual test and production environments. Lambda handles visitor tracking, DynamoDB for state, and automated CI/CD via Terraform and GitHub Actions.

Visit my site here! [Kaleb Castillo](https://kalebcastillo.com)

<img width="1882" height="1132" alt="Site Infrastructure Diagram" src="https://github.com/user-attachments/assets/22b3bae1-f0b8-49f6-8b7a-29664961a8b8" />


## Infrastructure Design

🌐 The frontend is a static Astro website hosted on S3. Route53 manages DNS, pointing to a Cloudfront distribution for CDN.

- Here is the Astro template I used: [fuwari](https://github.com/saicaca/fuwari)

🏗️ The backend visitor counter feature is a Lambda function written in Python which queries DynamoDB for view counts.

- I followed Rishab Kumar's [Guide](https://www.youtube.com/watch?v=x6TIihJSaLA&list=PLK_LRl1CH4L_ko1-Xm04ATPTduu6gaSM8&index=4) 

🔄 Dual environments, test and production, are managed through Terraform and GitHub Actions. The infrastructure uses modular design with separate test.tfvars and prod.tfvars files, each with
their own S3 backend Terraform state. This enables seamless CI/CD workflows. The test environment deploys automatically while the production environment requires a manual approval following
successful tests.

## Deployment Guide

I've designed this project so that anyone can fork and deploy it with minimal setup. Use it as a template for your own cloud portfolio.

## Table of Contents

1. 📋 [Prerequisites](#prerequisites)
2. 🚀 [Initial Setup](#initial-setup)
3. ☁️ [AWS Account Setup](#aws-account-setup)
4. 🔧 [Configure Local Environment](#configure-local-environment)
5. 📦 [Configure Terraform S3 Backend](#configure-terraform-s3-backend)
6. 🏗️ [Bootstrap Terraform S3 Backend](#bootstrap-terraform-s3-backend)
7. ✨ [Personalize Your Portfolio](#personalize-your-portfolio)
8. 🧪 [Deploy to Test Environment](#deploy-to-test-environment)
9. 🌐 [Deploy to Production](#deploy-to-production)
10. 🔄 [Set Up GitHub Workflows](#set-up-github-workflows)
11. 📝 [To Do](#to-do)
11. 🤝 [Contributions](#contributions)
12. 📜 [License](#license)

## 📋 Prerequisites

Before starting, ensure you have the following installed and configured:

- **VS Code with WSL (I use Ubuntu)**
  - [Setup WSL](https://learn.microsoft.com/en-us/windows/wsl/install) 
  - [Download VS Code](https://code.visualstudio.com/)
  - Install the "Remote - WSL" extension
  - Install the "Dev Containers" extension

- **Git**
  ```bash
  sudo apt-get update && sudo apt-get install git
  ```
  
- **Docker Desktop** - For the Devcontainer
  - [Download](https://www.docker.com/products/docker-desktop)
  - After installation, ensure Docker daemon is running
  
- **Terraform** - IaC
  - [Installation Steps](https://developer.hashicorp.com/terraform/install)
  - Verify installation: `terraform version`

- **Node.js** - Optional for local testing
  - [Installation Steps](https://nodejs.org/en/download)

## 🚀 Initial Setup

### 1. Fork and Clone the Repo

```bash
git clone https://github.com/<YOUR_PROFILE>/<YOUR_REPO>.git
```

### 2. Reopen in Dev Container

VS Code will detect the dev container and prompt you to reopen in container. Click **"Reopen in Container"** when prompted.

## ☁️ AWS Account Setup

### 1. Create AWS Account

- Go to [AWS Console](https://console.aws.amazon.com/)
- Create your account and add payment information.

### 2. Register a Domain

- Go to **Route53** in AWS Console
- Click **Domains** → **Register domain**
- Search for and purchase your domain
- Route53 will automatically create the hosted zone

## 🔧 Configure Local Environment

### 1. Create AWS user for Terraform

- Go to **IAM** in AWS Console
- Click **Users** → **Create User**
- Enter username: `terraform`
- On Permissions page, select "Attach policies directly"
- Search for and attach: `AdministratorAccess` (temporarily)
- **Next** → **Create User**
- Go to **Security Credentials** tab
- **Create Access Key**
- Choose "Local code/AWS CLI"
- **Next** → **Create Access Key**
- **Save your Access Key ID and Secret Access Key** - you'll need these

### 2. Apply Principle of Least Privilege Policy

Now replace the broad permissions with a more restrictive policy:

- Copy the policy from `terraform-policy.json` in the project root
- Go to your Terraform user
- **Add permissions** → **Create inline policy**
- Choose **JSON** tab
- Paste the policy
- Click **Create policy**
- Remove the `AdministratorAccess` policy

### 3. Configure Terraform Profile

Create a credentials file on your local machine:

```bash
mkdir -p ~/.aws
touch ~/.aws/credentials
chmod 600 ~/.aws/credentials
```

Add the profile

```ini
[terraform]
aws_access_key_id = <YOUR_ACCESS_KEY_ID>
aws_secret_access_key = <YOUR_SECRET_ACCESS_KEY>
region = <YOUR_REGION>
```

### 4. Verify AWS Configuration

```bash
# Test that Terraform can access AWS
aws sts get-caller-identity --profile terraform

# You should see output like:
# {
#     "UserId": "...",
#     "Account": "123456789",
#     "Arn": "arn:aws:iam::123456789:user/terraform"
# }
```

## 📦 Configure Terraform S3 Backend

### 1. Update Terraform Variables

Edit `infra/test.tfvars` and `infra/prod.tfvars` with your information.

### 2. Update Backend Configuration

Edit `infra/backend/test-backend.hcl` and `infra/backend/prod-backend.hcl` with your information.

## 🏗️ Bootstrap Terraform S3 Backend

The "backend" folder contains the infrastructure for Terraform state management. You only need to do this once.

### 1. Navigate to Backend Directory

```bash
cd infra/backend
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Apply Backend Infrastructure

```bash
terraform apply
```

Review the resources to be created and apply.

## ✨ Personalize Your Portfolio

Visit the Astro template [repo](https://github.com/saicaca/fuwari) for a usage guide. But here are some pointers:

### - Update Site Configuration

Edit `site/src/config.ts`:

### - Update Profile and About Page

Edit `site/src/content/spec/about.md`

### - Update Footer

Edit `site/src/components/Footer.astro`

### - Create Blog Posts

Use the built-in script to create new posts:

```bash
cd site
pnpm new-post <post_title>
```

## 🧪 Deploy to Test Environment

### 1. Build the Site Locally

First test that the site builds correctly:

```bash
cd site
pnpm install
pnpm build
```

Run the local dev environment and view the site at http://localhost:4321

```bash
pnpm dev
```

### 2. Initialize Test Terraform State

```bash
cd infra
terraform init -backend-config="backend/test-backend.hcl"

# When asked to copy existing state, type "no"
```

### 3. Plan and Verify

```bash
terraform plan -var-file="test.tfvars"
```

### 4. Deploy

```bash
terraform apply -var-file="test.tfvars"
```

### 5. Deploy Site Content

```bash
aws s3 sync site/dist/ s3://your_test_bucket/ --delete --profile terraform
```

## 🌐 Deploy to Production

- Visit your test site URL
- Verify everything looks correct

### 1. Initialize Production Terraform State

```bash
cd infra

terraform init -backend-config="backend/prod-backend.hcl"
# When asked about existing state, type "no"
```

### 2. Plan and Deploy

- Follow Steps from test, but use "prod.tfvars"

```bash
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
aws s3 sync site/dist/ s3://your_prod_bucket/ --delete --profile terraform
```

## 🔄 Set Up GitHub Workflows

### 1. Create GitHub Secrets

Add these Actions Secrets to your repo:

```
Name: AWS_ACCESS_KEY_ID
Value: Your Key ID

Name: AWS_SECRET_ACCESS_KEY
Value: Your Key
```

### 2. Review Workflow Configuration

The GitHub Actions workflow is configured in `.github/workflows/deploy.yml`. When you push to main, it will:

1. Run code quality checks for Astro content
2. Build the site
3. Deploy to test environment
4. Run tests
5. **Await manual approval** before production
6. Deploy to production upon approval

Make sure to make adjustments to the deploy.yml as necessary with your information.

Now you can develop your blog locally. Pushes to your repo will deploy straight to AWS.

## 📝 To Do

- Improve tests.
- Implement ephemeral preview environments.

## 🤝 Contributions

Feel free to contribute! I'm always learning and will be glad to improve this project further.

## 📜 License

This project is licensed under the MIT License.
