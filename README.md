# AWS CloudFront Terraform Configuration

This repository contains Terraform configuration to automate the creation of an **Amazon CloudFront distribution** with an S3 origin, deployed via **GitHub Actions**.

---

## 📁 Project Structure

```
aws-cloudfront-main/
├── README.md
├── backend.tf              # S3 backend configuration
├── main.tf                 # CloudFront and S3 resources
├── outputs.tf              # Output values
├── provider.tf             # AWS provider configuration
├── variables.tf            # Input variable definitions
├── .github/
│   └── workflows/
│       └── deploy.yml      # GitHub Actions CI/CD pipeline
└── environments/
    ├── dev.tfvars          # Development environment variables
    ├── uat.tfvars          # UAT environment variables
    └── prod.tfvars         # Production environment variables
```

---

## 🚀 What It Does

- Creates an **S3 bucket** as CloudFront origin with versioning and encryption
- Provisions a **CloudFront distribution** with Origin Access Control (OAC)
- Configures **cache behaviors** and **geo-restrictions**
- Supports **custom SSL certificates** via ACM
- Stores Terraform state in a **remote S3 backend**
- Automates deployment via **GitHub Actions**
- Enforces **manual approval** before applying changes

---

## 📋 Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** installed (v1.5.7+)
3. **GitHub repository** with the following secrets configured:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION` (e.g., `us-east-1`)
   - `INFRACOST_API_KEY` (optional, for cost estimation)

---

## ⚙️ Configuration

### Backend Configuration (`backend.tf`)

Update the S3 bucket name for storing Terraform state:

```hcl
terraform {
  backend "s3" {
    bucket  = "terraform-state-cloudfront"  # Change this to your bucket name
    key     = "cloudfront/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
```

### Environment Variables

Edit the `.tfvars` files in the `environments/` directory:

**`environments/dev.tfvars`:**
```hcl
aws_region         = "us-east-1"
environment        = "dev"
origin_bucket_name = "my-cloudfront-origin-dev-bucket"  # Must be globally unique
```

**Key Variables:**
- `origin_bucket_name`: S3 bucket name (must be globally unique)
- `aliases`: Custom domain names (requires ACM certificate)
- `acm_certificate_arn`: ARN of ACM certificate for HTTPS with custom domain
- `price_class`: CloudFront price class (`PriceClass_100`, `PriceClass_200`, `PriceClass_All`)

---

## 🛠️ Local Deployment

### Step 1: Initialize Terraform

```bash
terraform init
```

### Step 2: Validate Configuration

```bash
terraform validate
```

### Step 3: Plan Deployment

```bash
terraform plan -var-file="environments/dev.tfvars"
```

### Step 4: Apply Configuration

```bash
terraform apply -var-file="environments/dev.tfvars"
```

---

## 🔄 GitHub Actions Deployment

### Automatic Deployment (on push to main)

1. Push code to the `main` branch
2. GitHub Actions will automatically:
   - Run `terraform plan` for the **dev** environment
   - Generate cost estimation with Infracost
   - Wait for manual approval
   - Apply the changes

### Manual Deployment (for specific environments)

1. Go to **Actions** tab in GitHub
2. Select **"Terraform CloudFront Deployment"** workflow
3. Click **"Run workflow"**
4. Choose environment (`dev`, `uat`, or `prod`)
5. Click **"Run workflow"**

### Manual Approval

1. Go to **Actions** → select the running workflow
2. Find the **"Terraform Apply"** job
3. Click **"Review deployments"**
4. Click **"Approve and deploy"**

---

## 📊 Outputs

After deployment, Terraform outputs the following:

| Output | Description |
|--------|-------------|
| `cloudfront_distribution_id` | CloudFront distribution ID |
| `cloudfront_domain_name` | CloudFront domain name (e.g., `d123456.cloudfront.net`) |
| `cloudfront_distribution_arn` | ARN of the distribution |
| `s3_bucket_name` | Name of the S3 origin bucket |
| `origin_access_control_id` | OAC ID for S3 access |

**View outputs:**
```bash
terraform output
```

---

## 🌐 Accessing Your CloudFront Distribution

After deployment, access your CloudFront distribution using:

```
https://<cloudfront_domain_name>/
```

Example: `https://d123abc456def.cloudfront.net/`

To use a **custom domain** (e.g., `cdn.example.com`):

1. Create an ACM certificate in `us-east-1` region
2. Add the certificate ARN to your `.tfvars` file:
   ```hcl
   acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxx"
   aliases = ["cdn.example.com"]
   ```
3. Create a CNAME record in Route 53 or your DNS provider pointing to the CloudFront domain

---

## 🗑️ Cleanup

To destroy all resources:

```bash
terraform destroy -var-file="environments/dev.tfvars"
```

**Warning:** This will delete the CloudFront distribution and S3 bucket.

---

## 📝 Environment Setup in GitHub

### 1. Add GitHub Secrets

Go to **Settings → Secrets and variables → Actions** and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `INFRACOST_API_KEY` (optional)

### 2. Create Environment for Approval

1. Go to **Settings → Environments**
2. Click **"New environment"**
3. Name it: `dev-approval`, `uat-approval`, or `prod-approval`
4. Under **Deployment protection rules**, check **"Required reviewers"**
5. Add your GitHub username
6. Click **"Save protection rules"**

---

## 🔒 Security Best Practices

1. ✅ **Enable versioning** on S3 buckets (already configured)
2. ✅ **Enable encryption** on S3 buckets (already configured)
3. ✅ **Use Origin Access Control** (OAC) instead of OAI (already configured)
4. ✅ **Enable HTTPS only** with `redirect-to-https` viewer policy
5. ✅ **Use TLSv1.2 or higher** for SSL/TLS
6. ⚠️ **Restrict S3 bucket access** - only CloudFront can access via OAC
7. ⚠️ **Use custom domain with ACM certificate** for production

---

## 🆘 Troubleshooting

### Issue: "Bucket name already exists"

**Solution:** S3 bucket names must be globally unique. Change `origin_bucket_name` in your `.tfvars` file.

### Issue: "Access Denied" when accessing CloudFront

**Solution:** Ensure the S3 bucket policy allows CloudFront OAC access (automatically configured).

### Issue: CloudFront deployment takes long

**Solution:** CloudFront distributions can take 15-20 minutes to deploy. Set `wait_for_deployment = false` in variables to skip waiting (not recommended for production).

---

## 📚 Additional Resources

- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [CloudFront Origin Access Control](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html)

---

## 📄 License

This project is licensed under the MIT License.

---

## 👥 Contributing

Contributions are welcome! Please open an issue or submit a pull request.

---

**Happy CloudFront Deploying! 🚀**
