#iam.tf

##############################################
# EC2용 IAM Role 구성 (Filebeat에서 S3/SQS 접근)
##############################################

# EC2가 맡을 수 있는 역할로 지정하기 위한 Assume Role 정책
data "aws_iam_policy_document" "filebeat_assume" {
  statement {
    actions = ["sts:AssumeRole"]  # 역할을 위임받을 수 있도록 허용

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]  # EC2 인스턴스가 이 역할을 맡을 수 있도록 설정
    }
  }
}

# IAM 역할 생성 (filebeat-ec2-role)
# EC2 인스턴스가 S3, SQS에 접근할 수 있도록 설정된 역할
resource "aws_iam_role" "filebeat_role" {
  name               = "filebeat-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.filebeat_assume.json
}

# 역할에 부여할 정책 정의
# S3 로그 버킷에서 객체를 읽고, SQS로부터 메시지를 수신하는 권한 부여
resource "aws_iam_role_policy" "filebeat_policy" {
  name = "filebeat-access-policy"
  role = aws_iam_role.filebeat_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # S3 접근 권한 부여
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",         # 객체 다운로드
          "s3:ListBucket",        # 버킷 목록 조회
          "s3:GetBucketLocation"  # 버킷 위치 정보 조회
        ],
        Resource = [
          var.cloudtrail_s3_bucket_arn,
          "${var.cloudtrail_s3_bucket_arn}/*",

          var.guardduty_s3_bucket_arn,
          "${var.guardduty_s3_bucket_arn}/*",

          var.vpc_flow_log_s3_bucket_arn,
          "${var.vpc_flow_log_s3_bucket_arn}/*"
        ]
      },

      # SQS 접근 권한 부여
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",       # 메시지 수신
          "sqs:DeleteMessage",        # 메시지 삭제
          "sqs:GetQueueAttributes"    # 큐 속성 조회
        ],
        Resource = [
          var.cloudtrail_sqs_queue_arn,
          var.guardduty_sqs_queue_arn,
          var.vpc_flow_sqs_queue_arn
        ]
      }
    ]
  })
}

# EC2 인스턴스에 역할을 연결하기 위한 Instance Profile 생성
# 실제 EC2에서 role을 사용하려면 profile 형태로 연결해야 함
resource "aws_iam_instance_profile" "filebeat_profile" {
  name = "filebeat-ec2-instance-profile"
  role = aws_iam_role.filebeat_role.name
}

# 현재 AWS 계정 정보 (필요 시 계정 ID 참조용)
data "aws_caller_identity" "current" {}
