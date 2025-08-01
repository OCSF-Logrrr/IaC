#guardduty.tf

############################################
# GuardDuty 활성화 및 S3 결과 저장 설정
############################################

# GuardDuty 탐지기 생성 (기본 활성화 상태)
resource "aws_guardduty_detector" "main" {
  enable = true # GuardDuty 기능 활성화
  finding_publishing_frequency = "FIFTEEN_MINUTES" # 15분마다 결과 게시
}



