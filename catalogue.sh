echo -e "\e[33m Disabling Default nodejs \e[0m"
dnf module disable nodejs -y    &>>/tmp/roboshop.log

echo -e "\e[31m Enable nodejs 18 version \e[0m"
dnf module enable nodejs:18 -y    &>>/tmp/roboshop.log

echo -e "\e[31m Installing nodejs \e[0m"
dnf install nodejs -y   &>>/tmp/roboshop.log

echo -e "\e[31m Adding roboshop user \e[0m"
useradd roboshop    &>>/tmp/roboshop.log

echo -e "\e[31m Create App Dir \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m  Downloading App Code\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Unzip App Code \e[0m"
cd /app
unzip /tmp/catalogue.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Download dependencies \e[0m"
cd /app
npm install &>>/tmp/roboshop.log

echo -e "\e[31m Setup systemd catalogue service \e[0m"
cp /home/centos/roboshop1-shell/catalogue.service /etc/systemd/system/catalogue.service   &>>/tmp/roboshop.log


echo -e "\e[31m  Start catalogue service \e[0m"
systemctl daemon-reload   &>>/tmp/roboshop.log
systemctl enable catalogue    &>>/tmp/roboshop.log
systemctl restart catalogue     &>>/tmp/roboshop.log

echo -e "\e[31m Setup mongoDB repo \e[0m"
cp /home/centos/roboshop1-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>/tmp/roboshop.log

echo -e "\e[31m Install Mongodb client \e[0m"
dnf install mongodb-org-shell -y    &>>/tmp/roboshop.log

echo -e "\e[31m Load schema \e[0m"
mongo --host mongodb-dev.smitdevops.online </app/schema/catalogue.js    &>>/tmp/roboshop.log