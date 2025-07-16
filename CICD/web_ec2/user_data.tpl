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

#BIND9 설치
sudo apt-get install bind9 -y

#BIND9 Zone 파일 생성
cat << 'EOF' > /etc/bind/db.${domain_name}.zone
$TTL 604800
@   IN  SOA  ${nameservers[0]}.${domain_name}. root.${domain_name}. (
            2 604800 86400 2419200 604800 )
;
@ IN A ${eip}
%{ for ns in nameservers ~}
@ IN NS ${ns}.${domain_name}.
${ns} IN A ${eip}
%{ endfor ~}
EOF

#BIND9 Zone 파일 등록
cat << 'EOF' >> /etc/bind/named.conf.default-zones
zone "${domain_name}" {
        type master;
        file "/etc/bind/db.${domain_name}.zone";
};
%{ if enable_reverse_zone ~}
zone "${reverse_zone_name}" {
        type master;
        file "/etc/bind/zones/${reverse_zone_file}";
};
%{ endif ~}
EOF

#BIND9 Options 파일 설정
cat << 'EOF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable
        // nameservers, you probably want to use them as forwarders.
        // Uncomment the following block, and insert the addresses replacing
        // the all-0's placeholder.

        forwarders {
                8.8.8.8;
        };

        allow-query { any; };
        allow-query-cache { any; };

        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================
        dnssec-validation auto;

        listen-on-v6 { any; };
};
EOF

#BIND9 로깅 디렉토리 생성
sudo mkdir /var/log/named

#BIND9 로깅 파일 생성
sudo touch /var/log/named/query.log

#BIND9 로깅 파일 생성
sudo touch /var/log/named/named.log

#BIND9 로깅 파일 권한 수정
sudo chown -R bind:bind /var/log/named

#BIND9 로깅 설정
cat << 'EOF' > /etc/bind/named.conf.local
logging {
    channel querylog {
        file "/var/log/named/query.log" versions 10 size 10m;
        severity info;
        print-time yes;
    };
    channel default_log {
        file "/var/log/named/named.log" versions 10 size 10m;
        severity info;
        print-time yes;
    };
    category queries { querylog; };
    category default { default_log; };
    category general { default_log; };
};
EOF

#BIND9 재시작
sudo systemctl restart bind9

#Nginx 설치
sudo apt install -y nginx

#Nginx 리버스 프록시 설정
cat << 'EOF' > /etc/nginx/sites-available/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html/nginx;

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
                proxy_cache_bypass $http_upgrade;
        }

        location /webapi/ {
        proxy_pass http://127.0.0.1:8080/;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;

                rewrite ^/webapi/(.*)$ /$1 break;
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

#Apache2 재시작
systemctl restart apache2

#PHP 로깅 설정
sed -i 's/^;log_errors = .*/log_errors = On/' /etc/php/7.4/apache2/php.ini
echo "error_log = /var/log/php_errors.log" >> /etc/php/7.4/apache2/php.ini
touch /var/log/php_errors.log
chmod 644 /var/log/php_errors.log

#Apache 게시판 코드 디렉토리 생성
cd /tmp
git clone https://github.com/OCSF-Logrrr/Linux.git
mkdir -p /var/www/html/apache2
mkdir -p /var/www/html/apache2/files
cp -r /tmp/Linux/Web_Code/Board1/* /var/www/html/apache2/
chown -R www-data:www-data /var/www/html/apache2
chmod -R 755 /var/www/html/apache2

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
apt install -y nodejs npm
cd /opt
git clone https://github.com/snoopysecurity/dvws-node chatapi
cd chatapi
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install 16.19.0
nvm use 16.19.0
nvm alias default 16.19.0
npm install
nohup node app.js > /var/log/chatapi.log 2>&1 &

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

#Filebeat 설치
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.6.2-amd64.deb
sudo dpkg -i filebeat-8.6.2-amd64.deb

#Filebeat.yml 파일 수정
export IP_PORT=${ip_port}
curl -o /etc/filebeat/filebeat.yml.tpl https://raw.githubusercontent.com/OCSF-Logrrr/filebeat/main/web_filebeat.yml
envsubst < /etc/filebeat/filebeat.yml.tpl > /etc/filebeat/filebeat.yml

sudo systemctl enable filebeat
sudo systemctl start filebeat