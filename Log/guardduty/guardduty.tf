#guardduty.tf

############################################
# GuardDuty 활성화 및 S3 결과 저장 설정
############################################

# GuardDuty 탐지기 생성 (기본 활성화 상태)
resource "aws_guardduty_detector" "main" {
  enable = true # GuardDuty 기능 활성화
}

# GuardDuty의 S3 데이터 이벤트 탐지 기능 활성화
resource "aws_guardduty_detector_feature" "s3_logs" {
  detector_id = aws_guardduty_detector.main.id  # 연결할 GuardDuty 탐지기 ID
  name  = "S3_DATA_EVENTS"  # 기능 이름 (S3 로그 분석)
  status  = "ENABLED" # 활성화 상태
}

# S3 결과를 저장하기 위한 publishing Destination 리소스
resource "aws_guardduty_publishing_destination" "main" {
  detector_id     = aws_guardduty_detector.main.id  # GuardDuty 탐지기 ID
  destination_arn = var.s3_bucket_arn # 결과를 저장할 S3 버킷 ARN
  kms_key_arn   = aws_kms_key.guardduty.arn # 저장 시 사용할 KMS 키 ARN
}

############################################
# GuardDuty가 S3 버킷에 로그를 업로드할 수 있도록 정책 정의
############################################

data "aws_iam_policy_document" "guardduty_s3" {
  # [필수 정책 1] GuardDuty가 S3 버킷에 탐지 결과를 업로드할 수 있도록 허용
  statement {
    sid    = "AWSGuardDutyWrite"  # 정책 식별자
    effect = "Allow"  # 허용
    actions   = ["s3:PutObject"] # 객체 업로드 권한
    resources = ["${var.s3_bucket_arn}/*"] # 버킷 내 전체 객체에 대해 권한 부여
    principals {
      type        = "Service" # 주체 유형: AWS 서비스
      identifiers = ["guardduty.amazonaws.com"] # 권한을 부여할 서비스 주체: GuardDuty
    }

    condition {
      test     = "StringEquals" # 조건: 문자열 일치
      variable = "s3:x-amz-acl" # 요청 헤더의 ACL 설정값
      values   = ["bucket-owner-full-control"]  # S3 버킷 소유자가 업로드된 객체의 소유권을 완전히 가짐
    }
  }
  
  # [필수 정책 2] GuardDuty가 S3 버킷 위치 정보를 조회할 수 있도록 허용
  statement {
    sid = "Allow GetBucketLocation" # 정책 식별자
    actions = ["s3:GetBucketLocation"]  # 버킷 위치 정보 조회 권한
    resources = [var.s3_bucket_arn] # 버킷 자체에 대해 권한 부여
    principals {
      type = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }
}

############################################
# 위 정책을 S3 버킷에 적용
############################################

resource "aws_s3_bucket_policy" "guardduty_result_bucket" {
  bucket = var.s3_bucket_id # 정책을 적용할 S3 버킷 이름
  policy = data.aws_iam_policy_document.guardduty_s3.json # 위에서 정의한 정책 JSON
}


