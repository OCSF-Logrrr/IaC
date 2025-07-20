#iam.tf

# EC2가 맡을 IAM 역할 (Assume Role 정책)
data "aws_iam_policy_document" "filebeat_assume" {
  statement {
    actions = ["sts:AssumeRole"] # EC2가 이 역할을 맡을 수 있도록 허용

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"] # EC2 서비스가 이 역할을 맡는 주체임을 명시
    }
  }
}

# IAM 역할 생성 : EC2에서 S3/SQS 접근 권한을 부여하기 위한 역할
resource "aws_iam_role" "filebeat_role" {
  name               = "filebeat-ec2-role" # 역할 이름
  assume_role_policy = data.aws_iam_policy_document.filebeat_assume.json
}

# 역할에 부여할 정책 : S3 객체 읽기 + SQS 메시지 수신
resource "aws_iam_role_policy" "filebeat_policy" {
  name = "filebeat-access-policy"
  role = aws_iam_role.filebeat_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        # S3 버킷 접근 권한 부여
        Effect = "Allow",
        Action = [
          "s3:GetObject",      # S3 객체 다운로드
          "s3:ListBucket",      # S3 버킷 내 객체 리스트 조회 
          "s3:GetBucketLocation"      
        ],
        Resource = [
          var.cloudtrail_s3_bucket_arn, # CloudTrail S3 버킷 ARN
          "${var.cloudtrail_s3_bucket_arn}/*", # CloudTrail S3 버킷 내 모든 객체

          var.guardduty_s3_bucket_arn, # GuardDuty S3 버킷 ARN
          "${var.guardduty_s3_bucket_arn}/*", # GuardDuty S3 버킷 내 모든 객체
          
          var.vpc_flow_log_s3_bucket_arn, # VPC Flow Log S3 버킷 ARN
          "${var.vpc_flow_log_s3_bucket_arn}/*" # VPC Flow Log S3 버킷 내 모든 객체
        ]
      },
      {
        # SQS 큐에서 메시지 읽기 및 삭제 권한
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",         # 메시지 수신
          "sqs:DeleteMessage",          # 메시지 삭제 (처리 완료 시)
          "sqs:GetQueueAttributes"      # 큐 속성 조회
        ],
        Resource = [
          var.cloudtrail_sqs_queue_arn, # SQS 큐 ARN
          var.guardduty_sqs_queue_arn,  # SQS 큐 ARN
          var.vpc_flow_sqs_queue_arn     # SQS 큐 ARN
        ]
      }
    ]
  })
}

# EC2 인스턴스에 IAM 역할 연결하는 Instance Profile 생성
resource "aws_iam_instance_profile" "filebeat_profile" {
  name = "filebeat-ec2-instance-profile"
  role = aws_iam_role.filebeat_role.name
}

data "aws_caller_identity" "current" {}