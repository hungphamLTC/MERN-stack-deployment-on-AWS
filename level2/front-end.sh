#!/bin/bash
sudo apt update -y
sudo apt install npm -y
sudo apt install nginx -y
sudo apt install git -y
# still get the problem when the repository code cannot be downloaded
sudo git clone https://github.com/vladimirmukhin/instagram-mern.git

rm -rf /root/instagram-mern/backend
cd /root/instagram-mern/frontend
mkdir server_logs
npm install # download all dependencies
npm run build

mkdir /var/www/hungpham.link
cp -r /root/instagram-mern/* /var/www/hungpham.link/

sudo chown -R www-data.www-data /var/www/hungpham.link/
sudo chmod -R 755 /var/www/hungpham.link/

rm -f /etc/nginx/nginx.conf
wget -0 nginx.conf https://github.com/hungphamLTC/MERN-stack-deployment-on-AWS/blob/mern-stack-deployment/server-configuration/nginx.conf
sudo mv nginx.conf /etc/nginx/

wget -O default.conf https://raw.githubusercontent.com/hungphamLTC/MERN-stack-deployment-on-AWS/mern-stack-deployment/server-configuration/default.conf
sudo mv default.conf /etc/nginx/conf.d/

sudo nginx -t # check the syntax
sudo service nginx restart

