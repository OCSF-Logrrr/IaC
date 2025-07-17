#vpc_flow_log.tf

############################################
# VPC Flow Log → S3 저장 구성
############################################

# VPC Flow Log 생성
resource "aws_flow_log" "main" {
  log_destination = var.s3_bucket_arn # 로그를 저장할 S3 버킷 ARN
  log_destination_type  = "s3"  # 로그 저장 위치 유형 (S3 또는 CloudWatch 가능)
  traffic_type  = "ALL" # ALL: 수신/송신/거부 트래픽 모두 수집
  vpc_id  = "vpc-09edd77bad579d171"  # Flow Log를 설정할 대상 VPC ID
}


############################################
# VPC Flow Log 수집을 위해 필요한 IAM Role 및 정책 구성
############################################

# VPC Flow Log가 S3에 접근할 수 있도록 할 IAM Role 생성
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpc-flow-log-role"

# 이 역할을 VPC Flow Logs 서비스가 맡을 수 있도록 위임 정책(assume role policy) 정의
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole" # 이 역할을 맡을 수 있는 권한
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com" # 이 역할을 맡을 주체: VPC Flow Logs 서비스
        }
      },
    ]
  })
}

# 위 IAM Role에 실제 S3 접근 권한을 부여하는 정책 정의
resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name  = "vpc-flow-log-policy"
  role  = aws_iam_role.vpc_flow_log_role.id # 연결할 IAM Role ID 

 # S3에 로그를 업로드하기 위한 권한 정책 정의
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "s3:PutObject", # 로그 업로드
          "s3:GetBucketLocation", # 버킷 리전 조회
          "s3:ListBucket" # 버킷 내 객체 목록 조회
        ]
        Resource = [
          var.s3_bucket_arn,  # S3 버킷 자체에 대한 권한
          "${var.s3_bucket_arn}/*"  # S3 버킷 내부 객체에 대한 권한
        ]
      },
    ]
  })
}
