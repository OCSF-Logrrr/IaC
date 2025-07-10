#vpc.tf

#VPC 생성
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr #VPC CIDR 블록 지정
  enable_dns_support   = true #VPC에서 내부에서 dns 사용 가능
  enable_dns_hostnames = true #VPC 내 리소스에 dns 부여

  tags = {
    Name = "${var.project_name}-VPC"
  }
}

#퍼블릭 서브넷 생성
resource "aws_subnet" "public_subnet_01" {
  vpc_id               = aws_vpc.vpc.id  #VPC 선택
  cidr_block           = var.public_subnet_cidr_01 #퍼블릭 서브넷의 CIDR
  availability_zone    = var.availability_zone_01 #퍼블릭 서브넷이 위치할 가용 영역

  tags = {
    Name = "${var.project_name}-public-subnet-01" #서브넷 이름 지정 
    Type = "Public"
  }
}

#프라이빗 서브넷 생성
resource "aws_subnet" "private_subnet_01" {
  vpc_id               = aws_vpc.vpc.id  #VPC 선택
  cidr_block           = var.private_subnet_cidr_01 #프라이빗 서브넷의 CIDR
  availability_zone    = var.availability_zone_02 #프라이빗 서브넷이 위치할 가용 영역

  tags = {
    Name = "${var.project_name}-private-subnet-01" #서브넷 이름 지정
    Type = "Private"
  }
}
resource "aws_subnet" "private_subnet_02" {
  vpc_id               = aws_vpc.vpc.id  #VPC 선택
  cidr_block           = var.private_subnet_cidr_02 #프라이빗 서브넷의 CIDR
  availability_zone    = var.availability_zone_03 #프라이빗 서브넷이 위치할 가용 영역

  tags = {
    Name = "${var.project_name}-private-subnet-02" #서브넷 이름 지정
    Type = "Private"
  }
}
resource "aws_subnet" "private_subnet_03" {
  vpc_id               = aws_vpc.vpc.id  #VPC 선택
  cidr_block           = var.private_subnet_cidr_03 #프라이빗 서브넷의 CIDR
  availability_zone    = var.availability_zone_04 #프라이빗 서브넷이 위치할 가용 영역

  tags = {
    Name = "${var.project_name}-private-subnet-03" #서브넷 이름 지정
    Type = "Private"
  }
}

#인터넷 게이트웨이 생성
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id  #VPC 선택

  tags = {
    Name = "${var.project_name}-internet-gateway" #igw 이름 지정
  }
}

#퍼블릭 서브넷용 라우트 테이블 생성
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id  #VPC 선택

  route { #라우트 규칙 정의
    cidr_block = "0.0.0.0/0" #서브넷에서 나가는 모든 트래픽이
    gateway_id = aws_internet_gateway.internet_gateway.id #인터넷 게이트웨이를 통하도록 설정
  }

  tags = {
    Name = "${var.project_name}-public-route" #라우트 테이블 이름 지정
  }
}

#퍼블릭 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "route_table_public_subnet_01" {
  subnet_id      = aws_subnet.public_subnet_01.id #첫 번째 퍼블릭 서브넷 선택
  route_table_id = aws_route_table.route_table.id #퍼블릭 서브넷용 라우트 테이블에 연결
}

#NAT Instance에서 사용될 Elastic IP 생성
resource "aws_eip" "natinstance_eip" {
  domain = "vpc"
}

#NAT Instance 생성
resource "aws_instance" "nat_instance" {
  ami                         = "ami-01ad0c7a4930f0e43" #nat 인스턴스 생성을 위해 미리 세팅된 ami
  instance_type               = "t3.nano" #인스턴스 유형
  subnet_id                   = aws_subnet.public_subnet_01.id #퍼블릭 서브넷 id
  associate_public_ip_address = false #퍼블릭 ip 자동 할당 비활성화 (아래 블록에서 고정적인 eip 할당)
  source_dest_check           = false #소스/대상 확인 비활성화 (nat instance를 생성할 땐 꺼야함)

  tags = {
    Name = "${var.project_name}-nat-instance"
  }
}

#NAT Instance에 EIP 연결
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.nat_instance.id #nat instance id
  allocation_id = aws_eip.natinstance_eip.id #eip id
}

#프라이빗 서브넷용 라우트 테이블 생성
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id  #VPC 선택

  route { #라우트 규칙 정의
    cidr_block     = "0.0.0.0/0" #서브넷에서 나가는 모든 트래픽이
    nat_gateway_id = aws_instance.nat_instance.id #nat instance를 통하도록 설정
  }

  tags = {
    Name = "${var.project_name}-private-route" #라우트 테이블 이름 지정
  }
}

#프라이빗 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "route_table_private_subnet_01" {
  subnet_id      = aws_subnet.private_subnet_01.id #첫 번째 프라이빗 서브넷 선택
  route_table_id = aws_route_table.private_route_table.id #프라이빗 서브넷용 라우트 테이블에 연결
}
resource "aws_route_table_association" "route_table_private_subnet_02" {
  subnet_id      = aws_subnet.private_subnet_02.id #두 번째 프라이빗 서브넷 선택
  route_table_id = aws_route_table.private_route_table.id #프라이빗 서브넷용 라우트 테이블에 연결
}
resource "aws_route_table_association" "route_table_private_subnet_03" {
  subnet_id      = aws_subnet.private_subnet_03.id #세 번째 프라이빗 서브넷 선택
  route_table_id = aws_route_table.private_route_table.id #프라이빗 서브넷용 라우트 테이블에 연결
}