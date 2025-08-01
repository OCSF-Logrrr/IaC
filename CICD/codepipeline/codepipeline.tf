#codepipeline.tf

#Codepipeline 역할
resource "aws_iam_role" "pipeline_role" {
  name = "${var.project_name}PipelineRole" #역할 이름

  assume_role_policy = jsonencode({ #codepipeline에서 사용 가능
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

#고객관리형 정책
resource "aws_iam_policy" "pipeline_policy" {
  name        = "${var.project_name}PipelineRole"
  description = "Codebuild, CodeDeploy, S3, EC2"

  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"s3:*",
				"codedeploy:*",
				"ec2:*",
				"codebuild:*"
			],
			"Resource": "*"
		}
	]
  })
}

#역할에 정책 연결
resource "aws_iam_role_policy_attachment" "pipeline_policy_attachment" {
  role       = aws_iam_role.pipeline_role.name
  policy_arn = aws_iam_policy.pipeline_policy.arn
}

#git과 연결
resource "aws_codestarconnections_connection" "this" {
  name          = "GitHub CICD"
  provider_type = "GitHub"
}

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

#파이프라인 생성
resource "aws_codepipeline" "pipeline" {
  name     = "${var.project_name}-CICD-Pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codebuild_s3.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner      = var.git_owner
        Repo       = var.git_repo_name
        Branch     = "master"
        OAuthToken = var.github_oauth_token
      }
    }
  }
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        "ProjectName" = var.codebuild_name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      version          = "1"
      input_artifacts  = ["build_output"]
      configuration = {
        ApplicationName     = "${var.project_name}-CodeDeploy"
        DeploymentGroupName = "${var.project_name}-CodeDeploy-web-server"
      }
    }
  }
}