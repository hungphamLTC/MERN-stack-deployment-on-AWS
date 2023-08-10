#!/bin/bash
sudo apt update -y
sudo apt install npm -y
sudo apt install nginx -y
sudo apt install git -y

sudo git clone https://github.com/vladimirmukhin/instagram-mern.git /var/tmp/instagram-mern


rm -rf /var/tmp/instagram-mern/backend
cd /var/tmp/instagram-mern/frontend
mkdir server_logs
npm install # download all dependencies
npm run build

mkdir /var/www/hungpham.link
cp -r /var/tmp/instagram-mern/* /var/www/hungpham.link/

sudo chown -R www-data.www-data /var/www/hungpham.link/
sudo chmod -R 755 /var/www/hungpham.link/

rm -f /etc/nginx/nginx.conf
sudo wget -O /etc/nginx/nginx.conf https://github.com/hungphamLTC/MERN-stack-deployment-on-AWS/raw/mern-stack-deployment/server-configuration/nginx.conf

wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/hungphamLTC/MERN-stack-deployment-on-AWS/mern-stack-deployment/server-configuration/default.conf


sudo nginx -t # check the syntax
sudo service nginx restart

