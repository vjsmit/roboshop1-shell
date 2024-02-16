component=catalogue

color="\e[35m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"

echo -e "${color}Disabling Default nodejs${no_color}"
dnf module disable nodejs -y    &>>${log_file}

echo -e "${color}Enable nodejs 18 version${no_color}"
dnf module enable nodejs:18 -y    &>>${log_file}

echo -e "${color}Installing nodejs${no_color}"
dnf install nodejs -y   &>>${log_file}

echo -e "${color}Adding roboshop user${no_color}"
useradd roboshop    &>>${log_file}

echo -e "${color}Create App Dir${no_color}"
rm -rf /app
mkdir /app

echo -e "${color}Downloading App Code${no_color}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip    &>>${log_file}

echo -e "${color}Unzip App Code${no_color}"
cd /app
unzip /tmp/${component}.zip    &>>${log_file}

echo -e "${color}Download dependencies${no_color}"
cd /app
npm install &>>${log_file}

echo -e "${color}Setup systemd ${component} service${no_color}"
cp /home/centos/roboshop1-shell/${component}.service /etc/systemd/system/${component}.service   &>>${log_file}


echo -e "${color}Start ${component} service${no_color}"
systemctl daemon-reload   &>>${log_file}
systemctl enable ${component}    &>>${log_file}
systemctl restart ${component}     &>>${log_file}

echo -e "${color}Setup mongoDB repo${no_color}"
cp /home/centos/roboshop1-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>${log_file}

echo -e "${color}Install Mongodb client${no_color}"
dnf install mongodb-org-shell -y    ${log_file}

echo -e "${color}Load schema${no_color}"
mongo --host mongodb-dev.smitdevops.online </app/schema/${component}.js    &>>${log_file}