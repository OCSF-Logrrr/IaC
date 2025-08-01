# IaC

[![AWS](https://img.shields.io/badge/AWS-Deployed-232F3E?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-1.0%2B-623CE4?logo=terraform&logoColor=white)](https://terraform.io/)
[![HCL](https://img.shields.io/badge/HCL-623CE4?logo=hcl&logoColor=white)](https://github.com/hashicorp/hcl)

_This repository contains the Terraform code that provisions AWS infrastructure for log collection and attack simulation, as part of the WHS 3th OCSF-based Security Log Integration and Analysis Project._

<img width="1316" height="277" alt="AWS_infra" src="https://github.com/user-attachments/assets/161d0d60-718c-4004-83aa-f867042011e5" />

# Directory Structure

```bash
IaC/
├── CICD/  #PHP-based web server CICD pipeline infrastructure
│   ├── main.tf
│   ├── provider.tf
│   ├── backend.tf
│   ├── alb/  #Application Load Balancer, ALB Security Group, ALB Target Group, ALB Listener
│   ├── codebuild/  #CodeBuild IAM Role, CodeBuild
│   ├── codedeploy/  #CodeDeploy IAM Role, CodeDeploy Application, CodeDeploy Deployment Group
│   ├── codepipeline/  #CodePipeline IAM Role, CodePipeline, S3
│   ├── db_ec2/ #DB EC2 Security Group, EIP, DB EC2
│   ├── vpc/  #VPC, Subnet, IGW, Route Table
│   └── web_ec2/  #WEB EC2 Security Group, EIP, WEB EC2, Route53 zone
├── LAN/  #internal infrastructure
│   ├── main.tf
│   ├── provider.tf
│   ├── backend.tf
│   ├── bastion_window_ec2/  #Bastion EC2 Security Group, EIP, Bastion EC2
│   ├── data_linux_ec2/  #Data EC2 Security Group, Data EC2
│   ├── db_linux_ec2/  #(LAN)DB EC2 Security Group, (LAN)DB EC2
│   ├── pivot_linux_ec2/  #Pivot EC2 Security Group, Pivot EC2
│   └── vpc/  #VPC, Subnet, IGW, Route Table, NAT Instance(EIP, EC2)
├── Log/  #Log generation and collection infrastructure
│   ├── main.tf
│   ├── provider.tf
│   ├── backend.tf
│   ├── cloudtrail/  #CloudTrail, CloudTrail S3
│   ├── eventbridge/  #GuardDuty EventBridge, GuardDuty SQS
│   ├── filebeat_ec2/ #Filebeat Security Group, Filebeat EC2, EIP, Filebeat EC2 IAM Role, VPC, Subnet, IGW, Route Table
│   ├── guardduty/  #GuardDuty, S3 KMS key
│   ├── lambda/  #Lambda IAM Role, Lambda SQS Trigger, Lambda Function
│   ├── s3/  #GuardDuty Log S3, VPC Flow Log S3, CloudTrail Log S3
│   ├── sqs/  #GuardDuty SQS, VPC Flow Log SQS, CloudTrail SQS, SQS IAM Role
│   └── vpc_flow_log/  #VPC Flow Log, VPC Flow Log IAM Role
└── README.md

24 directories, 81 files
```

# Description of each directory

## CICD
<img width="1000" alt="CICD_infra" src="https://github.com/user-attachments/assets/8827d716-3f00-4500-807c-3f7b679b0bc5" />

**PHP-based web server CICD pipeline infrastructure**

We have designed a CI/CD pipeline with the goal of collecting logs generated from operating web and database servers on Ubuntu Linux using AWS services. The pipeline is triggered whenever PHP code in the GitHub repository is updated, which initiates the workflow through AWS CodePipeline. The updated PHP code is stored in an S3 bucket for CodeBuild, where the build process is executed according to predefined steps. Once the build completes, CodeDeploy performs an in-place deployment, updating the current environment with the new code. After this process, the CodePipeline finishes and the web server is updated with the latest code.

Detailed infrastructure configurations for the web server and database server can be found in the repository below.
- [**Linux**](https://github.com/OCSF-Logrrr/Linux)

The PHP codebase is also available in the repository linked below.
- [**CICD-Code**](https://github.com/OCSF-Logrrr/CICD-Code)

## LAN
<img width="600" alt="LAN_infra" src="https://github.com/user-attachments/assets/20eeb1d7-664f-4504-a462-c624c1290ceb" />

**internal infrastructure**

We designed attack scenarios exploiting AWS vulnerabilities and built an internal network—which should not be accessible in a real-world environment—on both Windows and Ubuntu systems. This environment was set up in a separate VPC from the previously mentioned CI/CD pipeline. The bastion server (Windows EC2) is placed in a public subnet, while the pivot, data, and database servers (Ubuntu EC2 instances) are located in private subnets. In this setup, we were able to collect Windows Event Logs, and the Ubuntu servers were configured with a vulnerable 20.04 version to generate logs from various CVE exploitation attempts. The internal infrastructure was used for the purposes of attack simulation and log collection.

## Log
<img width="600" alt="Log_infra" src="https://github.com/user-attachments/assets/dff2323c-88bb-4327-af32-b34b00c16d3d" />

**Log generation and collection infrastructure**

Logs generated inside EC2 instances—such as those from Nginx and MySQL—were forwarded to a broker server using agents like Filebeat installed within the EC2s. AWS logs such as CloudTrail, VPC Flow Logs, and GuardDuty required additional configuration to be collected with Filebeat. Specifically, when CloudTrail and VPC Flow Logs are generated, they are stored in an S3 bucket, which Filebeat then monitors and collects. GuardDuty logs are sent to Kafka via a Lambda function.
