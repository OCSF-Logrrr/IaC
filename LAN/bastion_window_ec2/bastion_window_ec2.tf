#window_ec2.tf

#window server용 보안그룹 생성
resource "aws_security_group" "window_server_sg" {
  name        = "${var.project_name}-window-sg" #보안 그룹 이름
  description = "Window Server Security Group" #설명
  vpc_id      = var.vpc_id #vpc 선택
}

#window server용 보안그룹 인바운드 규칙 생성 - rdp 허용
resource "aws_vpc_security_group_ingress_rule" "window_in_all_rdp" {
  security_group_id = aws_security_group.window_server_sg.id #보안 그룹 참조 (window server용 보안 그룹 참조)
  cidr_ipv4         = "0.0.0.0/0" #모든 트래픽
  from_port         = "3389" #rdp 포트
  ip_protocol       = "tcp" #tcp
  to_port           = "3389" #rdp 포트
}

#window server용 보안그룹 아웃바운드 규칙 생성 - 전체 허용
resource "aws_vpc_security_group_egress_rule" "window_out_all" {
  security_group_id = aws_security_group.window_server_sg.id #보안 그룹 참조 (window server용 보안 그룹 참조)
  cidr_ipv4         = "0.0.0.0/0" #모든 트래픽 허용
  ip_protocol       = "-1" #모든 프로토콜과 포트 허용
}

#eip 생성
resource "aws_eip" "window_server_eip" {
  domain = "vpc"
}

#인스턴스 생성
resource "aws_instance" "window_server_instance" {
  ami                       = "" #ami 이름 (지역별로 고유) -> Window
  instance_type             = "t2.micro" #인스턴스 유형
  key_name                  = var.key_name #키페어 이름
  subnet_id                 = var.public_subnet_id_01 #퍼블릭 서브넷 id
  vpc_security_group_ids    = [aws_security_group.window_server_sg.id] #보안 그룹 id

  root_block_device { #스토리지
    volume_size           = 8 #볼륨 크기
    volume_type           = "gp3" #볼륨 유형
    iops                  = 3000 #프로비저닝된 iops 값
    delete_on_termination = true #인스턴스 종료 시 삭제 여부
    encrypted             = true #암호화 여부
    kms_key_id            = "alias/aws/ebs" #기본값 aws/ebs 키 사용
    throughput            = 125 #처리량
  }

  instance_initiated_shutdown_behavior = "stop" #EC2 종료 시 중지

  metadata_options { #인스턴스 메타데이터 옵션
    http_endpoint               = "enabled" #메타데이터 액세스 기능 활성화
    http_protocol_ipv6          = "disabled" #메타데이터 IPv6 비활성화
    http_tokens                 = "required" #버전 V2만 사용하도록 토큰 필요 여부 활성화
    http_put_response_hop_limit = 2 #홉 수 제한
    instance_metadata_tags      = "disabled" #메타데이터에서 인스턴스 태그 접근 비활성화
  }

  user_data = templatefile("${path.module}/user_data.tpl")
}

#인스턴스에 eip 연결
resource "aws_eip_association" "window_server_eip_association" {
  instance_id   = aws_instance.window_server_instance.id
  allocation_id = aws_eip.window_server_eip.id
}