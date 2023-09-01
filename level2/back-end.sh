#!/bin/bash
sudo apt update -y
sudo apt install npm -y
sudo apt install git -y
sudo git clone https://github.com/vladimirmukhin/instagram-mern.git /home/ubuntu/instagram-mern

mv /home/ubuntu/instagram-mern/backend/config/config.env.example /home/ubuntu/instagram-mern/backend/config/config.env

#edit conf.env file

# cd /home/ubuntu/instagram-mern
# npm install
# npm start
