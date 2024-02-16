component=catalogue

color="\e[35m"
nocolor="\e[0m"

echo -e "${color}Disabling Default nodejs${no_color}"
dnf module disable nodejs -y    &>>/tmp/roboshop.log

echo -e "${color}Enable nodejs 18 version${no_color}"
dnf module enable nodejs:18 -y    &>>/tmp/roboshop.log

echo -e "${color}Installing nodejs${no_color}"
dnf install nodejs -y   &>>/tmp/roboshop.log

echo -e "${color}Adding roboshop user${no_color}"
useradd roboshop    &>>/tmp/roboshop.log

echo -e "${color}Create App Dir${no_color}"
rm -rf /app
mkdir /app

echo -e "${color}Downloading App Code${no_color}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip    &>>/tmp/roboshop.log

echo -e "${color}Unzip App Code${no_color}"
cd /app
unzip /tmp/${component}.zip    &>>/tmp/roboshop.log

echo -e "${color}Download dependencies${no_color}"
cd /app
npm install &>>/tmp/roboshop.log

echo -e "${color}Setup systemd ${component} service${no_color}"
cp /home/centos/roboshop1-shell/${component}.service /etc/systemd/system/${component}.service   &>>/tmp/roboshop.log


echo -e "${color}Start ${component} service${no_color}"
systemctl daemon-reload   &>>/tmp/roboshop.log
systemctl enable ${component}    &>>/tmp/roboshop.log
systemctl restart ${component}     &>>/tmp/roboshop.log

echo -e "${color}Setup mongoDB repo${no_color}"
cp /home/centos/roboshop1-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>/tmp/roboshop.log

echo -e "${color}Install Mongodb client${no_color}"
dnf install mongodb-org-shell -y    &>>/tmp/roboshop.log

echo -e "${color}Load schema${no_color}"
mongo --host mongodb-dev.smitdevops.online </app/schema/${component}.js    &>>/tmp/roboshop.log