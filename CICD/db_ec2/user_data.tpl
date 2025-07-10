#!/bin/bash

#user data 로그 기록
exec > /var/log/user_data.log 2>&1

#패키지 리스트 업데이트
sudo apt update -y
sudo apt upgrade -y

#패키지 설치
sudo apt install -y gnupg

#MongoDB 공개키 가져오기
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor

#MongoDB 저장소 리스트 추가
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

#패키지 리스트 업데이트
sudo apt update -y

#MongoDB 설치
sudo apt install -y mongodb-org

#MongoDB 실행
sudo systemctl enable mongod
sudo systemctl start mongod

#MySQL 설치
DEBIAN_FRONTEND=noninteractive sudo apt install -y mysql-server

#MySQL 실행
sudo systemctl enable mysql
sudo systemctl start mysql

#MySQL 로깅 파일 설정
mkdir -p /var/log/mysql
touch /var/log/mysql/mysql.log
chmod 644 /var/log/*/*.log
sudo chown mysql:mysql /var/log/mysql/mysql.log

#MySQL 쿼리 로그 설정
mysql -e "SET GLOBAL general_log = ON;"
mysql -e "SET GLOBAL general_log_file = '/var/log/mysql/mysql.log';"

#Filebeat 설치
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.6.2-amd64.deb
sudo dpkg -i filebeat-8.6.2-amd64.deb

#Filebeat.yml 파일 수정
export IP_PORT=${ip_port}
curl -o /etc/filebeat/filebeat.yml.tpl https://raw.githubusercontent.com/OCSF-Logrrr/filebeat/main/db_filebeat.yml
envsubst < /etc/filebeat/filebeat.yml.tpl > /etc/filebeat/filebeat.yml

sudo systemctl enable filebeat
sudo systemctl start filebeat