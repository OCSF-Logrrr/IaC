# IaC

[![HCL](https://img.shields.io/badge/HCL-623CE4?logo=hcl&logoColor=white)](https://github.com/hashicorp/hcl)
[![Terraform](https://img.shields.io/badge/Terraform-1.0%2B-623CE4?logo=terraform&logoColor=white)](https://terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Deployed-232F3E?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)

_This repository contains the Terraform code that provisions AWS infrastructure for log collection and attack simulation, as part of the WHS 3th OCSF-based Security Log Integration and Analysis Project._

---

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
