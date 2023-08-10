#!/bin/bash
sudo apt update -y
sudo apt install npm -y
sudo apt install nginx -y
sudo apt install git -y
# still get the problem when the repository code cannot be downloaded
git clone https://github.com/vladimirmukhin/instagram-mern.git

rm -rf /root/instagram-mern/backend
cd /root/instagram-mern/frontend
mkdir server_logs
npm install # download all dependencies
npm run build

mkdir /var/www/hungpham.link
cp -r /root/instagram-mern/* /var/www/hungpham.link/

sudo chown -R www-data.www-data /var/www/hungpham.link/
sudo chmod -R 755 /var/www/hungpham.link/

# the log_format cannot be injected to the file nginx.conf

echo "" > /etc/nginx/nginx.conf

sudo sh -c 'cat << EOF >> /etc/nginx/nginx.conf
user ubuntu;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    client_body_buffer_size 100k;
    client_header_buffer_size 1k;
    client_max_body_size 100k;
    large_client_header_buffers 2 1k;
    client_body_timeout 10;
    client_header_timeout 10;
    keepalive_timeout 5 5;
    send_timeout 10;
    server_tokens off;
    #gzip  on; on;

    include /etc/nginx/conf.d/*.conf;
}
EOF'

sudo touch /etc/nginx/conf.d/default.conf

sudo sh -c 'cat << EOF >> /etc/nginx/conf.d/default.conf
server {
    #listen       80;
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name  www.hungpham.link;

    access_log /var/www/hungpham.link/frontend/server_logs/host.access.log main;

    location / {
        root   /var/www/hungpham.link/frontend/build;
        index  index.html index.htm;
        try_files \$uri /index.html;
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        add_header Strict-Transport-Security "max-age=31536000; includeSubdomains;";
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    server_tokens off;

    location ~ /\.ht {
        deny  all;
    }
}
EOF'

sudo nginx -t # check the syntax
sudo service nginx restart

