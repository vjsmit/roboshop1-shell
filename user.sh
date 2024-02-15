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
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Unzip App Code \e[0m"
cd /app
unzip /tmp/user.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Download dependencies \e[0m"
cd /app
npm install &>>/tmp/roboshop.log

echo -e "\e[31m Setup systemd user service \e[0m"
cp /home/centos/roboshop1-shell/user.service /etc/systemd/system/user.service   &>>/tmp/roboshop.log


echo -e "\e[31m  Start user service \e[0m"
systemctl daemon-reload   &>>/tmp/roboshop.log
systemctl enable user    &>>/tmp/roboshop.log
systemctl restart user     &>>/tmp/roboshop.log
