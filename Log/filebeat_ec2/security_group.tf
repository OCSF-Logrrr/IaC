#security_group.tf

# 보안 그룹 생성
resource "aws_security_group" "filebeat_sg" {
  name        = "filebeat-security-group" # 보안 그룹 이름
  description = "Security group for Filebeat EC2 instances" # 보안 그룹 설명
  vpc_id      = aws_vpc.filebeat_vpc.id # 생성한 VPC에 연결

  ingress {
    from_port   = 22 # SSH 포트
    to_port     = 22 # SSH 포트
    protocol    = "tcp" # 프로토콜
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP에서 SSH 접근 허용
  }

  egress {
    from_port   = 0 # 모든 포트
    to_port     = 0 # 모든 포트
    protocol    = "-1" # 모든 프로토콜
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP에서 아웃바운드 트래픽 허용
  }

  tags = {
    Name = "filebeat-security-group" # AWS 콘솔에서 식별할 수 있도록 이름 부여
    type = "security_group"
  }
}