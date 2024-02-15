echo -e "\e[33m Disabling Default nodejs \e[0m"
dnf module disable nodejs -y    &>>/tmp/roboshop.log

echo -e "\e[31m Enable nodejs 18 version \e[0m"
dnf module enable nodejs:18 -y    &>>/tmp/roboshop.log

echo -e "\e[31m Installing nodejs \e[0m"
dnf install nodejs -y   &>>/tmp/roboshop.log

echo -e "\e[31m Adding roboshop cart \e[0m"
useradd roboshop    &>>/tmp/roboshop.log

echo -e "\e[31m Create App Dir \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m  Downloading App Code\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Unzip App Code \e[0m"
cd /app
unzip /tmp/cart.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Download dependencies \e[0m"
cd /app
npm install &>>/tmp/roboshop.log

echo -e "\e[31m Setup systemd cart service \e[0m"
cp /home/centos/roboshop1-shell/cart.service /etc/systemd/system/cart.service   &>>/tmp/roboshop.log


echo -e "\e[31m  Start cart service \e[0m"
systemctl daemon-reload   &>>/tmp/roboshop.log
systemctl enable cart    &>>/tmp/roboshop.log
systemctl restart cart     &>>/tmp/roboshop.log