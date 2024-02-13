echo -e "\e[33m Copy mongdb repo file \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m Installing MongoDB \e[0m"
dnf install mongodb-org -y

echo -e "\e33m Open mongodb service for all"
sed -i '\s\127.0.0.1\0.0.0.0\' /etc/mongod.conf

echo -e "\e[33m Restating mongodb service"
systemctl enable mongod
systemctl restart mongod