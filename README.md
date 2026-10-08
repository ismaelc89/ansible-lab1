# 3-Tier AWS Architecture with Terraform and Ansible

On this project we will provisioned a basic EC2 instance with the required network configuration to have ssh and http communication. Then we will apply the configuration with Ansible installing Apache and then copying an index file to test it

# Architecture Overview
```
Internet
                  │
                  ▼
        ┌───────────────────┐
        │ Internet Gateway  │
        └─────────┬─────────┘
                  │
 ┌────────────────┼────────────────────────────────────────────┐
 │ VPC (10.0.0.0/16)                                           │
 │                                                             │
 │   ┌─────────────────────────────────────────────────────┐   │
 │   │ Public Subnet (10.0.1.0/24)                         │   │
 │   │   - Route Table -> Internet Gateway                 │   │
 │   │                                                     │   │
 │   │   ┌─────────────────────────────────────────────┐   │   │
 │   │   │ Public EC2: Apache Web server.              │   │   │
 │   │   │ Security Group: Allow HTTP (80) & SSH (22)  │   │   │
 │   │   └──────────────────────┬──────────────────────┘   │   │
 │   └──────────────────────────-──────────────────────────┘   │
 │_____________________________________________________________│
```

# Repository Layout
```
├── ansible
│   ├── ansible.cfg                # Main configuration to be used with AWS
│   ├── inventory
│   │   └── aws_ec2.yml            # Dynamic AWS inventory
│   ├── site.yml                   # Main Ansible Playbook
│   └── templates
│       └── index.html.j2          # Template to be used for Apache 
├── README.md
└── terraform
    ├── datasource.tf              # AMI data source used for the instance creation and AZs that has instance type 
    ├── main.tf                    # EC2 instance, VPC, Subnets, Route Tables, IGW, and Security Groups
    ├── outputs.tf                 # Public Proxy IP, Private App IP, and AZs
    ├── providers.tf               # AWS provider configuration
    └── variables.tf               # Variables for terraform
```

# Prerequisites

- Terraform CLI installed (v1.0.0+).
- Ansible installed
- AWS CLI configured via aws configure.
- An SSH key pair created on your AWS account (for this practice we used one called "MyEC2KeyPair")


# Step-by-Step Deployment Guide

### Step 1: Clone the Repository & Navigate to Terraform Directory
```
git clone [https://github.com/](https://github.com/)/.git
cd /terraform
```
### Step 2: Initialize Terraform
Download the required AWS provider modules:
```
terraform init
```
### Step 3: Preview the Execution Plan
Review all resources Terraform intends to provision:
```
terraform plan
```
### Step 4: Apply Configuration
Deploy the architecture to AWS:
```
terraform apply -auto-approve
```
Upon completion, Terraform will output the server details:
- public_ip_ec2

# Start Configuration Management via Ansible

### Step 1: Navigate to Ansible Directory
```
cd /ansible
```
### Step 2: Verify that Ansible get proper info of inventory
```
ansible-inventory --graph
```
You should get the ip address of the ec2 instance
If you get any error please confirm that the path of the `private_key_file` is the correct one where your key pair is located if not please update and save file

### Step 3: Apply Ansible Playbook 
```
ansible-playbook site.yml
```

# Verification & Testing
1. Allow some minutes for the Ansible Playbook to finish installing and initializing Apache service.

2. Verify HTTP routing via `curl`:
```
curl http://<PUBLIC_IP>
```
3. Alternatively, open your browser and navigate to:
```
http://<PUBLIC_IP>
```
# Automated Teardown
To avoid incurring cloud provider charges after testing, destroy all provisioned infrastructure with a single command:
```
terraform destroy -auto-approve
```