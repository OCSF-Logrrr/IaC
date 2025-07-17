#cloudtrail.tf

##############################################
# CloudTrail 활성화
##############################################

resource "aws_cloudtrail" "main" {
  depends_on  = [aws_s3_bucket_policy.cloudtrail_log_bucket]  # CloudTrail이 S3에 로그를 저장하기 위해 필요한 버킷 정책이 먼저 적용되도록 순서 강제
  name  = "logrrr-cloudtrail"   # 생성할 CloudTrail의 이름
  s3_bucket_name  = var.s3_bucket_id  # 수집된 CloudTrail 로그를 저장할 대상 S3 버킷 이름
  include_global_service_events = false 
  # true로 하면 글로벌 서비스(API Gateway, IAM 등)의 이벤트도 수집
  # false인 경우 리전 단위의 서비스 이벤트만 수집함 (글로벌 이벤트 제외)
}

##############################################
# CloudTrail 로그를 S3 버킷에 저장할 수 있도록 정책을 정의
##############################################

data "aws_iam_policy_document" "cloudtrail" {
  # [필수 정책 1] CloudTrail 서비스가 S3 버킷의 ACL(소유자 확인)을 읽을 수 있도록 허용
  # -> s3:GetBucketAcl
  statement {
    sid = "AWSCloudTrailAclCheck"         # 정책 문서 내에서 이 권한 블록을 식별하기 위한 고유 ID
    effect = "Allow"                             # 아래 명시된 작업 (s3:GetBucketAcl)을 허용함 
    actions = ["s3:GetBucketAcl"]          # CloudTrail이 로그를 업로드하기 전, S3 버킷의 ACL(소유자 확인)을 확인할 수 있도록 허용
    resources = [var.s3_bucket_arn]         # 권한을 적용할 리소스 대상 정의(arn:aws:s3:::logrrr-cloudtrail-log-bucket)
    principals {
      type  = "Service"                    # 정책을 적용할 주체의 유형: AWS 서비스
      identifiers = ["cloudtrail.amazonaws.com"]  # 권한을 부여할 서비스 주체: Cloutrail
    }
  }

  # [필수 정책 2] CloudTrail이 로그 파일을 지정된 경로에 업로드할 수 있도록 허용
  # -> s3:PutObject
  statement {
    sid = "AWSCloudTrailWrite"              # 정책 문서 내에서 이 권한 블록을 식별하기 위한 고유 ID
    effect = "Allow"                             # 아래 명시된 작업 (s3:PutObject)을 허용함
    actions   = ["s3:PutObject"]               # CloudTrail이 로그 파일을 S3 버킷에 업로드할 수 있도록 허용
    resources = ["${var.s3_bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]  # CloudTrail이 로그를 저장할 대상 객체 경로
    principals {
      type        = "Service"                     # 정책을 적용할 주체의 유형: AWS 서비스
      identifiers = ["cloudtrail.amazonaws.com"]  # 권한을 부여할 서비스 주체: Cloutrail
    }
    # CloudTrail이 로그 업로드 시, 버킷 소유자가 로그 파일 전체 권한을 갖도록 설정(원래는 CloudTrail이 권한을 가져버림 이렇게 되면 소유자가 S3 버킷에 접근하지 못하는 상황이 발생하기 때문에 이 설정을 해주는 것)
    condition {
      test  = "StringEquals"                   # 조건 방식: 문자열이 정확하게 일치해야 함
      variable = "s3:x-amz-acl"                  # 업로드 시 요청 헤더에 포함된 ACL 값
      values  = ["bucket-owner-full-control"] # CloudTrail이 업로드하는 객체의 소유권을 버킷 소유자에게 완전히 넘기도록 요구
    }    
  }
}

# 현재 Terraform 실행에 사용 중인 AWS 계정 정보 조회 (계정 ID 등 참조용)
data "aws_caller_identity" "current" {}

############################################
# 위 정책을 S3 버킷에 적용
############################################

resource "aws_s3_bucket_policy" "cloudtrail_log_bucket" {
  bucket = var.s3_bucket_id                     # 정책을 적용할 S3 버킷(arn:aws:s3:::logrrr-cloudtrail-log-bucket)
  policy = data.aws_iam_policy_document.cloudtrail.json  # 적용할 정책 문서
}












