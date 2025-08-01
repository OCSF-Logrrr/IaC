#filebeat_ec2.tf

##############################################
# Filebeat 수집기 EC2 인스턴스 구성
##############################################

resource "aws_instance" "filebeat" {
  ami                    = "ami-0d5bb3742db8fc264"  # Ubuntu 또는 Filebeat 설치용 베이스 AMI ID
  instance_type          = "t2.micro"               # 테스트 용도로 사용되는 최소 사양 인스턴스
  subnet_id              = aws_subnet.filebeat_public_subnet.id  # 퍼블릭 서브넷에 배치
  vpc_security_group_ids = [aws_security_group.filebeat_sg.id]   # Filebeat용 보안그룹 적용
  key_name               = var.key_name             # SSH 접속용 키 페어 이름

  iam_instance_profile   = aws_iam_instance_profile.filebeat_profile.name  # S3, SQS 접근을 위한 IAM 역할 연결

  # EC2 초기 실행 시 실행될 셸 스크립트(user_data) 전달 (Filebeat 설치 및 설정)
  user_data = templatefile("${path.module}/user_data.tpl", {
    cloudtrail_event_queue_url    = var.cloudtrail_sqs_queue_url   # CloudTrail SQS 큐 URL
    guardduty_event_queue_url     = var.guardduty_sqs_queue_url    # GuardDuty SQS 큐 URL
    vpc_flow_event_queue_url      = var.vpc_flow_sqs_queue_url     # VPC Flow Logs SQS 큐 URL

    cloudtrail_s3_bucket_id       = var.cloudtrail_s3_bucket_id    # CloudTrail 로그 S3 버킷 ID
    cloudtrail_s3_bucket_arn      = var.cloudtrail_s3_bucket_arn   # CloudTrail 로그 S3 버킷 ARN

    guardduty_s3_bucket_id        = var.guardduty_s3_bucket_id     # GuardDuty 로그 S3 버킷 ID
    guardduty_s3_bucket_arn       = var.guardduty_s3_bucket_arn    # GuardDuty 로그 S3 버킷 ARN

    vpc_flow_log_s3_bucket_id     = var.vpc_flow_log_s3_bucket_id  # VPC Flow 로그 S3 버킷 ID
    vpc_flow_log_s3_bucket_arn    = var.vpc_flow_log_s3_bucket_arn # VPC Flow 로그 S3 버킷 ARN
  })

  tags = {
    Name = "filebeat-instance"   # EC2 식별용 태그
    type = "ec2_instance"
  }
}

##############################################
# EC2에 고정 퍼블릭 IP(EIP) 할당
##############################################

resource "aws_eip" "filebeat_eip" {
  instance = aws_instance.filebeat.id  # 위에서 만든 filebeat EC2에 EIP 연결

  tags = {
    Name = "filebeat-eip"  # EIP 리소스 식별용 태그
    type = "eip"
  }
}
