#codebuild.tf

#codebuild 역할
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}CodebuildRole" #역할 이름

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

#고객관리형 정책 생성
resource "aws_iam_policy" "codebuild_policy" {
  name        = "CodeBuildBasePolicy-${var.project_name}CodebuildRole-${var.region}"
  description = "Codebuild, Cloudwatch, S3"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/codebuild/${var.project_name}-Codebuild",
                "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/codebuild/${var.project_name}-Codebuild:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-${var.region}-*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:${var.region}:${local.account_id}:report-group/${var.project_name}-Codebuild-*"
            ]
        }
    ]
  })
}

#위에서 생성한 정책을 Codebuild 역할에 연결
resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

###########################################################################################
######################################## Main CodeBuild ###################################
###########################################################################################

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

#파이프라인에 포함될 codebuild
resource "aws_codebuild_project" "main_codebuild" {
  name          = "${var.project_name}-Codebuild"
  description   = "Codebuild included in the pipeline"
  service_role  = aws_iam_role.codebuild_role.arn #위에서 생성한 역할 설정

  artifacts {
    type = "NO_ARTIFACTS" #빌드 후 아티팩트 저장 X -> codepipeline에서 설정되기 때문
  }

  cache {
    type     = "NO_CACHE"
  }

  environment {
    compute_type   = "BUILD_GENERAL1_SMALL" #실행 컴퓨터 크기 -> 3GB, 2vCPU
    image          = "aws/codebuild/standard:7.0" 
    type           = "LINUX_CONTAINER" #리눅스 컨테이너
    image_pull_credentials_type = "CODEBUILD" #codebuild의 기본 이미지 사용
    privileged_mode = true #루트 권한 활성화 -> 빌드를 위해

    environment_variable {
      name  = "DB_SERVER"
      value = var.db_ec2_public_ip
    }

    environment_variable {
      name  = "DB_NAME"
      value = var.db_name
    }

    environment_variable {
      name  = "DB_USER"
      value = var.db_user
    }

    environment_variable {
      name  = "DB_PASSWORD"
      value = local.db_password
    }
  }

    source { #코드를 가져올 곳
    type      = "GITHUB" #git 선택
    location  = var.git_repo_url #git url
    buildspec = <<EOF
version: 0.2

phases:
  install:
    runtime-versions:
      php: 8.3
    commands:
      - cd apache2
      - |
        cat <<EOT > .env
        DB_SERVER=$DB_HOST
        DB_NAME=$DB_NAME
        DB_USER=$DB_USER
        DB_PASSWORD=$DB_PASSWORD
        EOT
      - composer install
      - cd ..

artifacts:
  files:
    - '**/*'
    - '!README.md'
  base-directory: .
  discard-paths: no
EOF
  }
}