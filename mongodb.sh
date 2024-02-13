echo -e "\e[33m Copy mongdb repo file \e[0m"
cp /centos/roboshop1-shellmongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[33m Installing MongoDB \e[0m"
dnf install mongodb-org -y &>>/tmp/roboshop.log

echo -e "\e33m Open mongodb service for all"
sed -i '\s\127.0.0.1\0.0.0.0\' /etc/mongod.conf &>>/tmp/roboshop.log

echo -e "\e[33m Restating mongodb service"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log