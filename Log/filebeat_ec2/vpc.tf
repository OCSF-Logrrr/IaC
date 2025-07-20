#vpc.tf

# VPC 생성
resource "aws_vpc" "filebeat_vpc" {
  cidr_block = var.vpc_cidr # VPC CIDR 블록 지정
  enable_dns_support = true # VPC에서 내부 DNS 사용 가능
  enable_dns_hostnames = true # VPC 내 리소스에 DNS 부여
  tags = {
    Name = "filebeat-vpc" # AWS 콘솔에서 식별할 수 있도록 이름 부여
    type = "vpc"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "filebeat_igw" {
  vpc_id = aws_vpc.filebeat_vpc.id  # 생성한 VPC에 연결
  tags = {
    Name = "filebeat-igw" # AWS 콘솔에서 식별할 수 있도록 이름 부여
    type = "igw"
  }
}

# 서브넷 생성
resource "aws_subnet" "filebeat_public_subnet" {
  vpc_id = aws_vpc.filebeat_vpc.id  # 생성한 VPC에 연결
  cidr_block = var.public_subnet_cidr # 퍼블릭 서브넷 CIDR
  availability_zone = var.availability_zone # 가용 영역 지정
  tags = { 
    Name = "filebeat-public-subnet" # AWS 콘솔에서 식별할 수 있도록 이름 부여
    type = "public_subnet"
  }
}

# 라우트 테이블 생성
resource "aws_route_table" "filebeat_route_table" {
  vpc_id = aws_vpc.filebeat_vpc.id  # 생성한 VPC에 연결
  route {
    cidr_block = "0.0.0.0/0" # 모든 트래픽을 인터넷 게이트웨이로 라우팅
    gateway_id = aws_internet_gateway.filebeat_igw.id # 인터넷 게이트웨이 ID
}
  tags = {
    Name = "filebeat-route-table" # AWS 콘솔에서 식별할 수 있도록 이름 부여
    type = "route_table"
  }
}

# 라우트 테이블과 퍼블릭 서브넷 연결
resource "aws_route_table_association" "filebeat_route_table_association" {
  subnet_id = aws_subnet.filebeat_public_subnet.id # 퍼블릭 서브넷 ID
  route_table_id = aws_route_table.filebeat_route_table.id # 라우트 테이블 ID
}