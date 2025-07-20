#filebeat_ec2.tf

resource "aws_instance" "filebeat" {
  ami                    = "ami-0d5bb3742db8fc264"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.filebeat_public_subnet.id
  vpc_security_group_ids = [aws_security_group.filebeat_sg.id]
  key_name               = var.key_name

  iam_instance_profile = aws_iam_instance_profile.filebeat_profile.name

  # user_data.tpl 파일을 EC2에 전달
  user_data = templatefile("${path.module}/user_data.tpl", {
    cloudtrail_event_queue_url              = var.cloudtrail_sqs_queue_url
    guardduty_event_queue_url               = var.guardduty_sqs_queue_url
    vpc_flow_event_queue_url                = var.vpc_flow_sqs_queue_url
    cloudtrail_s3_bucket_id   = var.cloudtrail_s3_bucket_id
    cloudtrail_s3_bucket_arn = var.cloudtrail_s3_bucket_arn
    guardduty_s3_bucket_id    = var.guardduty_s3_bucket_id
    guardduty_s3_bucket_arn = var.guardduty_s3_bucket_arn
    vpc_flow_log_s3_bucket_id = var.vpc_flow_log_s3_bucket_id
    vpc_flow_log_s3_bucket_arn = var.vpc_flow_log_s3_bucket_arn
  })

  tags = {
    Name = "filebeat-instance"
    type = "ec2_instance"
  }
}


#eip 생성
resource "aws_eip" "filebeat_eip" {
  instance = aws_instance.filebeat.id

  tags = {
    Name = "filebeat-eip"
    type = "eip"
  }
}