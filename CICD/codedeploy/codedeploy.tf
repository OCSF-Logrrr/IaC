#codedeploy.tf

#codedeploy 역할
resource "aws_iam_role" "codedeploy_role" {
  name = "${var.project_name}CodedeployRole" #역할 이름

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
}

#AWS 관리형 정책을 CodeDeploy 역할에 연결
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole
}

#CodeDeploy Application
resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "Server" #컴퓨팅 플랫폼 EC2
  name             = "${var.project_name}-CodeDeploy"
}

# resource "aws_sns_topic" "example" {
#   name = "example-topic"
# }

#CodeDeploy 배포 그룹
resource "aws_codedeploy_deployment_group" "codedeploy_group" {
  app_name              = aws_codedeploy_app.codedeploy_app.name #앱 선택
  deployment_group_name = "${var.project_name}-CodeDeploy-web-server"
  service_role_arn      = aws_iam_role.codedeploy_role.arn #위에서 생성한 역할 선택

  deployment_style { #배포 유형
    deployment_option = "WITH_TRAFFIC_CONTROL" #트래픽이 새 버전의 서버로 가도록
    deployment_type   = "IN_PLACE" #현재위치 배포
  }
  
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "${var.project_name}-web-instance"
    }
  }

  load_balancer_info{
    target_group_info{
      name = "${var.alb_target_group_name}"
    }
  }
}