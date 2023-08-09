sudo apt update -y
sudo apt install npm -y

git clone https://github.com/vladimirmukhin/instagram-mern.git
mv /root/instagram-mern/backend/config/config.env.example /root/instagram-mern/backend/config/config.env

#edit conf.enf file

cd /root/instagram-mern
npm install
npm start
