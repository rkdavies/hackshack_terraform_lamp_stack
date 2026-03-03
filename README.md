# Multi-Cloud LAMP Stack with Terraform

This project demonstrates a multi-cloud infrastructure deployment using Terraform, deploying a Django web application across AWS, GCP, and Azure.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Multi-Cloud LAMP Stack                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│   │     AWS      │  │     GCP      │  │    Azure     │              │
│   ├──────────────┤  ├──────────────┤  ├──────────────┤              │
│   │   VPC/Subnet │  │   VPC/Subnet │  │   VNet/Subnet│              │
│   │   EC2        │  │   Compute    │  │   VM         │              │
│   │   RDS MySQL  │  │   Cloud SQL  │  │   Azure SQL  │              │
│   │   ALB        │  │   Cloud LB   │  │   Load Bal.  │              │
│   └──────────────┘  └──────────────┘  └──────────────┘              │
│                                                                     │
│  Each cloud: Virtual Network + Compute + Database + Load Balancer   │
└─────────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
.
├── main.tf                    # Root module - calls all submodules
├── providers.tf               # Provider configuration (AWS, GCP, Azure)
├── variables.tf               # Root variable definitions
├── outputs.tf                 # Root output values
├── .gitignore                 # Git ignore patterns
├── environments/              # Environment-specific configurations
│   ├── dev/dev.tfvars        # Development variables
│   └── prod/prod.tfvars      # Production variables
├── modules/                   # Reusable modules
│   ├── aws/
│   │   ├── networking/       # VPC, subnets, security groups
│   │   ├── compute/          # EC2 instances
│   │   ├── database/         # RDS MySQL
│   │   └── loadbalancer/     # Application Load Balancer
│   ├── gcp/
│   │   ├── networking/       # VPC, subnets, firewall rules
│   │   ├── compute/          # Compute Engine instances
│   │   ├── database/         # Cloud SQL
│   │   └── loadbalancer/     # Global Load Balancer
│   └── azure/
│       ├── networking/       # Virtual Network, NSG
│       ├── compute/          # Linux Virtual Machines
│       ├── database/         # Azure SQL Database
│       └── loadbalancer/     # Azure Load Balancer
├── .github/workflows/         # CI/CD pipelines
│   └── terraform.yml         # GitHub Actions workflow
└── tests/                     # Test configurations
    ├── aws_mock.tftest.hcl
    ├── gcp_mock.tftest.hcl
    └── azure_mock.tftest.hcl
```

## Prerequisites

1. **Terraform** >= 1.0 installed
2. **Cloud Provider CLI** access:
   - AWS: Valid credentials configured (`aws configure`)
   - GCP: Service account key or `gcloud auth application-default login`
   - Azure: `az login` with sufficient permissions
3. **SSH Key** (optional): For SSH access to instances

## Quick Start

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Validate Configuration

```bash
# Check syntax
terraform fmt -check -recursive

# Validate resources
terraform validate
```

### 3. Plan and Apply

**Development Environment:**
```bash
terraform plan -var-file=environments/dev/dev.tfvars -out=tfplan
terraform apply tfplan
```

**Production Environment:**
```bash
terraform plan -var-file=environments/prod/prod.tfvars -out=tfplan
terraform apply tfplan
```

### 4. Destroy Resources

```bash
terraform destroy -var-file=environments/dev/dev.tfvars
```

## Configuration Guide

### Cloudflare DNS Configuration

Each compute instance automatically registers a DNS A record in Cloudflare when it comes up.

#### Prerequisites

1. **Cloudflare Account**: You need a Cloudflare account with a domain
2. **API Token**: Create an API token with the following permissions:
   - Zone: DNS:Read, DNS:Edit
   - Select the specific zone you want to use

#### Getting Cloudflare Credentials

1. Log into Cloudflare Dashboard
2. Go to Profile > API Tokens
3. Create a new token with DNS:Edit permissions
4. Get your Zone ID from the Cloudflare Dashboard (overview page)

#### Setting Variables

Add to your `environments/dev/dev.tfvars` or `environments/prod/prod.tfvars`:

```hcl
cloudflare_api_token = "your-api-token-here"
cloudflare_zone_id   = "your-zone-id-here"
cloudflare_domain    = "hackshack.sh"
```

#### DNS Records Created

The following A records are automatically created:

| Cloud | Record | Points To |
|-------|--------|-----------|
| AWS | `www.hackshack.sh` | AWS EC2 Public IP |
| GCP | `gcp.hackshack.sh` | GCP Instance External IP |
| Azure | `azure.hackshack.sh` | Azure VM Public IP |

**Note**: The AWS record uses `www` subdomain, while GCP and Azure use `gcp` and `azure` subdomains to avoid conflicts.

### Changing the Git Repository

The web application is deployed by cloning a Git repository during instance startup. To use a different repository:

#### Method 1: Update variables.tf

Add a new variable:
```hcl
variable "git_repo" {
  description = "Git repository URL to clone"
  type        = string
  default     = "git@github.com:rkdavies/hackshack_web.git"
}
```

#### Method 2: Update compute modules directly

Edit each cloud provider's compute module:

**AWS** (`modules/aws/compute/main.tf`):
```hcl
git clone git@github.com:your-username/your-repo.git /var/www/html/your-app
```

**GCP** (`modules/gcp/compute/main.tf`):
```hcl
git clone git@github.com:your-username/your-repo.git /var/www/html/your-app
```

**Azure** (`modules/azure/compute/main.tf`):
```hcl
git clone git@github.com:your-username/your-repo.git /var/www/html/your-app
```

#### For HTTPS instead of SSH

If you don't have SSH access configured, change:
```
git@github.com:your-username/your-repo.git
```
to:
```
https://github.com/your-username/your-repo.git
```

### Changing the Hostname

The hostname is set during instance initialization via cloud-init. To change from `www.hackshack.sh` to a custom hostname:

#### AWS EC2

In `modules/aws/compute/main.tf`, update the user_data script:

```hcl
user_data = <<-EOF
#!/bin/bash
hostnamectl set-hostname your-hostname.example.com
# ... rest of script
EOF
```

#### GCP Compute Engine

In `modules/gcp/compute/main.tf`, update both the metadata and startup-script:

```hcl
metadata = {
  hostname = "your-hostname.example.com"  # Pre-defined key
  startup-script = <<-EOF        # Custom startup script
#!/bin/bash
hostnamectl set-hostname your-hostname.example.com
# ... rest of script
EOF
}
```

#### Azure VM

In `modules/azure/compute/main.tf`, update custom_data:

```hcl
custom_data = base64encode(<<-EOF
#!/bin/bash
hostnamectl set-hostname your-hostname.example.com
# ... rest of script
EOF
)
```

### Changing the Apache ServerName

The Apache VirtualHost configuration uses ServerName to match incoming requests. Update in each compute module:

**All providers** - Update the Apache configuration:

```apache
<VirtualHost *:80>
    ServerName your-hostname.example.com
    DocumentRoot /var/www/html/hackshack_web
    # ... rest of config
</VirtualHost>
```

### Understanding Metadata Blocks

Each cloud provider handles instance metadata differently:

#### AWS (user_data)
```hcl
user_data = <<-EOF
#!/bin/bash
# Cloud-init directives
hostnamectl set-hostname www.hackshack.sh
apt-get update
# ... installation commands
EOF
```
- Passed to EC2 instance via user data
- Executed by cloud-init on first boot
- No size limit concerns

#### GCP (metadata)
```hcl
metadata = {
  hostname = "www.hackshack.sh"  # Pre-defined key
  startup-script = <<-EOF        # Custom startup script
#!/bin/bash
# ... commands
EOF
}
```
- `hostname`: Pre-defined metadata key for hostname
- `startup-script`: Google Cloud-specific startup
- Executed by cloud-init

#### Azure (custom_data)
```hcl
custom_data = base64encode(<<-EOF
#!/bin/bash
hostnamectl set-hostname www.hackshack.sh
# ... commands
EOF
)
```
- Must be base64 encoded
- Executed by cloud-init on first boot
- Azure Custom Script Extension alternative for larger scripts

## Testing and Validation

### 1. Syntax Validation

```bash
# Check formatting
terraform fmt -check -recursive

# If files need fixing
terraform fmt -recursive
```

### 2. Configuration Validation

```bash
terraform validate
```

Expected output:
```
Success! The configuration is valid.
```

### 3. Plan Review

```bash
# Generate plan without applying
terraform plan -var-file=environments/dev/dev.tfvars

# Save plan to file
terraform plan -var-file=environments/dev/dev.tfvars -out=tfplan
```

Review the plan output carefully:
- Check resource counts
- Verify expected resources are created
- Review any warnings

### 4. Test with Mock Providers (Advanced)

For isolated testing without cloud credentials:

```bash
# Using Terraform test framework (requires Terraform 1.6+)
terraform test
```

### 5. Validate Outputs

After apply, verify outputs:
```bash
terraform output

# Specific output
terraform output aws_lb_dns
terraform output gcp_lb_ip
terraform output azure_lb_ip
```

## Variable Reference

| Variable | Description | Default |
|----------|-------------|---------|
| `environment` | Environment name | `dev` |
| `aws_region` | AWS region | `us-east-1` |
| `gcp_project_id` | GCP project ID | `lamp-demo-project` |
| `gcp_region` | GCP region | `us-central1` |
| `vpc_cidr` | CIDR blocks per cloud | `10.0.0.0/16`, etc. |
| `instance_type` | VM sizes per cloud | Small/medium instances |
| `db_instance_class` | Database tiers per cloud | Micro/small instances |
| `db_name` | Database name | `lampdb` |
| `db_username` | Database admin | `admin` |
| `ssh_key_path` | SSH public key path | `~/.ssh/id_rsa.pub` |

## Security Considerations

1. **Database Passwords**: Use `db_password` variable - it's marked as sensitive
2. **SSH Keys**: Never commit private keys; use `.gitignore`
3. **Cloud Credentials**: Use environment variables or cloud provider IAM roles
4. **State Management**: Backend is configured for S3; consider state locking

## CI/CD Integration

The included GitHub Actions workflow (`.github/workflows/terraform.yml`) provides:

1. **Validate** - Runs on every PR
2. **Plan** - Posts plan to PR comments
3. **Apply** - Runs on merge to main

### Required Secrets

Configure in GitHub repository settings:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `GOOGLE_CREDENTIALS` (service account JSON)
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`

## Troubleshooting

### Instance fails to start

Check cloud-init logs:
```bash
# AWS
sudo cat /var/log/cloud-init-output.log

# GCP
gcloud compute instances get-serial-port-output INSTANCE_NAME

# Azure
az vm boot-diagnostics get-boot-logs -g RESOURCE_GROUP -n VM_NAME
```

### Cannot clone Git repository

1. Verify repository URL is correct
2. For SSH: Add deploy key to GitHub repository
3. For SSH: Verify instance has SSH key access
4. Alternative: Use HTTPS URL instead

### Database connection fails

1. Check security groups allow port 3306 (MySQL)
2. Verify database credentials
3. Check instance is in same VPC/subnet as database

## Cost Considerations

Each cloud provider offers free tiers:
- **AWS**: Free tier for 12 months (t3.micro, RDS t3.micro)
- **GCP**: Always free tier (e2-micro, Cloud SQL micro)
- **Azure**: Free tier for 12 months (B1s, SQL Database)

Remember to destroy resources when not in use:
```bash
terraform destroy -var-file=environments/dev/dev.tfvars
```

## License

MIT License - Feel free to use for learning and demonstration purposes.
