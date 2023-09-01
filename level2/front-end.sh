#!/bin/bash
sudo apt update -y
sudo apt install npm -y
sudo apt install nginx -y
sudo apt install git -y

sudo git clone https://github.com/vladimirmukhin/instagram-mern.git /home/ubuntu/instagram-mern


rm -rf /home/ubuntu/instagram-mern/backend
cd /home/ubuntu/instagram-mern/frontend
mkdir server_logs
npm install
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d www.hungpham.link

# copy site-enabled-default from repository to /etc/nginx/sites-enabled
