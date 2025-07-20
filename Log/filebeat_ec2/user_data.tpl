#!/bin/bash

set -e

echo "✅ Filebeat 설치 중..."

# 1. 필수 패키지 설치
apt-get update
apt-get install -y wget

# 2. Filebeat 다운로드 및 설치
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.6.2-amd64.deb
dpkg -i filebeat-8.6.2-amd64.deb

# 3. Filebeat 설정 덮어쓰기
cat <<EOF > /etc/filebeat/filebeat.yml
filebeat.inputs:

- type: aws-s3
  enabled: true
  queue_url: ${cloudtrail_event_queue_url}
  visibility_timeout: 10s
  tags: ["cloudtrail"]

- type: aws-s3
  enabled: true
  queue_url: ${guardduty_event_queue_url}
  visibility_timeout: 10s
  tags: ["guardduty"]

- type: aws-s3
  enabled: true
  queue_url: ${vpc_flow_event_queue_url}
  visibility_timeout: 10s
  tags: ["vpcflow"]

output.kafka:
  hosts: ["221.144.36.127:9092"]
  topic: "raw-aws-logs"
  partition.round_robin:
    reachable_only: true
  codec.json:
    pretty: false
  required_acks: 1
  compression: gzip
  max_message_bytes: 1000000
EOF

# 4. Filebeat 자동 시작 설정
systemctl enable filebeat
systemctl start filebeat

echo "✅ Filebeat 8.6.2 설치 및 설정 완료"
