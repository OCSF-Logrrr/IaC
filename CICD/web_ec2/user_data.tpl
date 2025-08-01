#!/bin/bash

#user data 로그 기록
exec > /var/log/user_data.log 2>&1

#패키지 리스트 업데이트
sudo apt update -y
sudo apt upgrade -y

#UFW 설치
sudo apt install ufw

#UFW 로깅 설정
cat << 'EOF' > /etc/rsyslog.d/20-ufw.conf
:msg,contains,"[UFW " /var/log/ufw.log

& stop
EOF

#UFW 활성화
sudo ufw enable

#rsyslog 재시작
systemctl restart rsyslog

#Nginx 설치
sudo apt install -y nginx

#Nginx 리버스 프록시 설정
cat << 'EOF' > /etc/nginx/sites-available/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html/nginx;
        index index.html index.htm index.nginx-debian.html;
        location / {
                proxy_pass http://127.0.0.1:8080; #here
                proxy_set_header Host $host; # here
                proxy_set_header X-Real-IP $remote_addr; #here
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /api/ {
                proxy_pass http://127.0.0.1:3000/api/;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_cache_bypass $http_upgrade;
        }

        location /webapi/ {
                proxy_pass http://127.0.0.1:8080/webapi/;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /css/ {
                root /var/www/html/apache2;
        }

        location ~ \.php$ {
                root /var/www/html/apache2;
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }
}
EOF

#Nginx 재시작
sudo systemctl restart nginx

#Apache2 & PHP & MySQL 설치
apt install -y apache2 php libapache2-mod-php php-mysql php-fpm git

#Apache2 포트 설정
cat << 'EOF' > /etc/apache2/ports.conf
Listen 8080

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
EOF

cat << 'EOF' > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:8080>
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/apache2
	
	<Directory /var/www/html/apache2>
		Require all granted
	</Directory>
	
	<FilesMatch \.php$>
    		SetHandler "proxy:unix:/run/php/php8.3-fpm.sock|fcgi://localhost/"
	</FilesMatch>

	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

#Apache2 재시작
sudo systemctl restart apache2

#PHP 로깅 설정
sed -i 's/^;log_errors = .*/log_errors = On/' /etc/php/8.3/apache2/php.ini
echo "error_log = /var/log/php_errors.log" >> /etc/php/8.3/apache2/php.ini
touch /var/log/php_errors.log
chmod 644 /var/log/php_errors.log

#Apache 게시판 코드 디렉토리 생성
cd /tmp
git clone https://github.com/OCSF-Logrrr/CICD-Code
mkdir -p /var/www/html/apache2
cp -r /tmp/CICD-Code/apache2/* /var/www/html/apache2/
mkdir -p /var/www/html/apache2/webapi/files
chown -R www-data:www-data /var/www/html/apache2
chmod -R 755 /var/www/html/apache2

cd /var/www/html/apache2
apt install composer -y
COMPOSER_ALLOW_SUPERUSER=1 composer require vlucas/phpdotenv

#Apache2 재시작
systemctl restart apache2

#Modsecurity 설치
apt install -y apache2 libapache2-mod-security2

#Modsecurity 설정
sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf

#Security2 모듈 활성화
sudo a2enmod security2

#Directory 권한 설정
sed -i '/<\/VirtualHost>/i \
<Directory /var/www/html>\n\
    Require all granted\n\
</Directory>' /etc/apache2/sites-enabled/000-default.conf

#OWASP CRS 설치
rm -rf /usr/share/modsecurity-crs
cd /etc/modsecurity
git clone https://github.com/coreruleset/coreruleset.git
cd coreruleset
cp crs-setup.conf.example crs-setup.conf
chown -R www-data:www-data /etc/modsecurity/coreruleset

#OWASP CRS 설정 파일 수정
echo -e '\nIncludeOptional /etc/modsecurity/coreruleset/crs-setup.conf' >> /etc/modsecurity/modsecurity.conf
echo 'IncludeOptional /etc/modsecurity/coreruleset/rules/*.conf' >> /etc/modsecurity/modsecurity.conf

#Apache2 재시작
systemctl restart apache2

#Node.js 설치 (node.js, npm 특정 버전 설치)
cd /tmp
git clone https://github.com/snoopysecurity/dvws-node
mkdir -p /var/www/html/nginx
cp -r /tmp/dvws-node/. /var/www/html/nginx
chown -R ubuntu:ubuntu /var/www/html/nginx
cd /var/www/html/nginx
cat <<EOF > /var/www/html/nginx/.env
EXPRESS_JS_PORT=3000
XML_RPC_PORT=9090
GRAPHQL_PORT=4000
JWT_SECRET=access
MONGO_LOCAL_CONN_URL=mongodb://${db_ec2_public_ip}:27017/test
MONGO_DB_NAME=test
SQL_LOCAL_CONN_URL=${db_ec2_public_ip}
SQL_DB_NAME=board
SQL_USERNAME=root
SQL_PASSWORD=1234
LOG_LEVEL=info
EOF
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install 16.19.0
nvm use 16.19.0
nvm alias default 16.19.0
npm install

#chatapi 애플리케이션 pm2로 실행
npm install -g pm2
pm2 start app.js --name dvws-api

#UFW 방화벽 설정
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

#Suricata 설치
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt update -y
sudo apt install -y suricata suricata-update jq

#Suricata 설정 파일 Github의 suricata.yaml 파일로 덮어쓰기
curl -o /etc/suricata/suricata.yaml https://raw.githubusercontent.com/OCSF-Logrrr/Linux/main/Suricata/suricata.yaml

#Suricata Rules 다운로드
curl -o /etc/suricata/rules/SQL_Injection.rules https://raw.githubusercontent.com/OCSF-Logrrr/Linux/main/Suricata/rules/SQL_Injection.rules
curl -o /etc/suricata/rules/XSS.rules https://raw.githubusercontent.com/OCSF-Logrrr/Linux/main/Suricata/rules/XSS.rules

sudo systemctl restart suricata

#auditd 설치
sudo apt-get install auditd audispd-plugins

sudo systemctl enable auditd
sudo systemctl start auditd

#auditd Rules 추가
sudo auditctl -a always,exit -F path=/usr/bin/curl -F perm=x -k webshell
sudo filebeat modules enable auditd



#Filebeat 설치
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.6.2-amd64.deb
sudo dpkg -i filebeat-8.6.2-amd64.deb

#Filebeat.yml 파일 수정
export IP_PORT=${ip_port}
curl -o /etc/filebeat/filebeat.yml.tpl https://raw.githubusercontent.com/OCSF-Logrrr/filebeat/main/web_filebeat.yml
envsubst < /etc/filebeat/filebeat.yml.tpl > /etc/filebeat/filebeat.yml

sudo systemctl enable filebeat
sudo systemctl start filebeat