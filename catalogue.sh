component=catalogue

color="\e[35m"
nocolor="\e[0m"

echo -e "${color}Disabling Default nodejs${no_color}"
dnf module disable nodejs -y    &>>/tmp/roboshop.log

echo -e "\e[31m Enable nodejs 18 version${no_color}"
dnf module enable nodejs:18 -y    &>>/tmp/roboshop.log

echo -e "\e[31m Installing nodejs${no_color}"
dnf install nodejs -y   &>>/tmp/roboshop.log

echo -e "\e[31m Adding roboshop user${no_color}"
useradd roboshop    &>>/tmp/roboshop.log

echo -e "\e[31m Create App Dir${no_color}"
rm -rf /app
mkdir /app

echo -e "\e[31m  Downloading App Code${no_color}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Unzip App Code${no_color}"
cd /app
unzip /tmp/${component}.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Download dependencies${no_color}"
cd /app
npm install &>>/tmp/roboshop.log

echo -e "\e[31m Setup systemd ${component} service${no_color}"
cp /home/centos/roboshop1-shell/${component}.service /etc/systemd/system/${component}.service   &>>/tmp/roboshop.log


echo -e "\e[31m  Start ${component} service${no_color}"
systemctl daemon-reload   &>>/tmp/roboshop.log
systemctl enable ${component}    &>>/tmp/roboshop.log
systemctl restart ${component}     &>>/tmp/roboshop.log

echo -e "\e[31m Setup mongoDB repo${no_color}"
cp /home/centos/roboshop1-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>/tmp/roboshop.log

echo -e "\e[31m Install Mongodb client${no_color}"
dnf install mongodb-org-shell -y    &>>/tmp/roboshop.log

echo -e "\e[31m Load schema${no_color}"
mongo --host mongodb-dev.smitdevops.online </app/schema/${component}.js    &>>/tmp/roboshop.log