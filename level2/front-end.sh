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

# the log_format cannot be injected to the file nginx.conf

echo "" > /etc/nginx/nginx.conf

sudo touch /etc/nginx/conf.d/default.conf

sudo nginx -t # check the syntax
sudo service nginx restart

