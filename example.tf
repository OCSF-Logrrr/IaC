###########################################################################################
##################################### Codebuild S3 ########################################
###########################################################################################

#Codebuild용 s3 버킷 생성
resource "aws_s3_bucket" "codebuild_s3" {
  bucket = "${var.project_name}-codebuild-s3" #버킷 이름 지정
}

#Codebuild용 s3 버킷 버전 관리
resource "aws_s3_bucket_versioning" "codebuild_s3_versioning" {
  bucket = aws_s3_bucket.codebuild_s3.id #codebuild용 s3 지정
  versioning_configuration {
    status = "Disabled" #버전 관리 비활성화
  }
}

#Codebuild용 s3 버킷 기본 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "codebuild_s3_encryption" {
  bucket = aws_s3_bucket.codebuild_s3.id #codebuild용 s3 지정

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" #SSE-S3 암호화
    }
  }
}

#Codebuild용 s3 버킷 퍼블릭 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "codebuild_s3_public_access" {
  bucket = aws_s3_bucket.codebuild_s3.id #codebuild용 s3 지정

  block_public_acls       = true #모든 퍼블릭 액세스 차단
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###########################################################################################
######################################## DAST S3 ##########################################
###########################################################################################

#DAST용 s3 버킷 생성
resource "aws_s3_bucket" "dast_result_s3" {
  bucket = "dast-result-s3" #버킷 이름 지정
}

#DAST용 s3 버킷 버전 관리
resource "aws_s3_bucket_versioning" "dast_result_s3_versioning" {
  bucket = aws_s3_bucket.dast_result_s3.id #dast용 s3 지정
  versioning_configuration {
    status = "Disabled" #버전 관리 비활성화
  }
}

#DAST용 s3 버킷 기본 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "dast_result_s3_encryption" {
  bucket = aws_s3_bucket.dast_result_s3.id #dast용 s3 지정

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" #SSE-S3 암호화
    }
  }
}

#DAST용 s3 버킷 퍼블릭 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "dast_result_s3_public_access" {
  bucket = aws_s3_bucket.dast_result_s3.id #dast용 s3 지정

  block_public_acls       = true #모든 퍼블릭 액세스 차단
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###########################################################################################
######################################## SAST S3 ##########################################
###########################################################################################

#SAST용 s3 버킷 생성
resource "aws_s3_bucket" "sast_result_s3" {
  bucket = "sast-result-s3" #버킷 이름 지정
}

#SAST용 s3 버킷 버전 관리
resource "aws_s3_bucket_versioning" "sast_result_s3_versioning" {
  bucket = aws_s3_bucket.sast_result_s3.id #sast용 s3 지정
  versioning_configuration {
    status = "Disabled" #버전 관리 비활성화
  }
}

#SAST용 s3 버킷 기본 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "sast_result_s3_encryption" {
  bucket = aws_s3_bucket.sast_result_s3.id #sast용 s3 지정

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" #SSE-S3 암호화
    }
  }
}

#SAST용 s3 버킷 퍼블릭 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "sast_result_s3_public_access" {
  bucket = aws_s3_bucket.sast_result_s3.id #sast용 s3 지정

  block_public_acls       = true #모든 퍼블릭 액세스 차단
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}