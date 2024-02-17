color="\e[32m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

func_nodejs() {
  echo -e "${color}Disabling Default nodejs${no_color}"
  dnf module disable nodejs -y    &>>${log_file}

  echo -e "${color}Enable nodejs 18 version${no_color}"
  dnf module enable nodejs:18 -y    &>>${log_file}

  echo -e "${color}Installing nodejs${no_color}"
  dnf install nodejs -y   &>>${log_file}

  echo -e "${color}Adding roboshop user${no_color}"
  useradd roboshop    &>>${log_file}

  echo -e "${color}Create App Dir${no_color}"
  rm -rf ${app_path}
  mkdir ${app_path}

  echo -e "${color}Downloading App Code${no_color}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip    &>>${log_file}

  echo -e "${color}Unzip App Code${no_color}"
  cd ${app_path}
  unzip /tmp/${component}.zip    &>>${log_file}

  echo -e "${color}Download dependencies${no_color}"
  cd ${app_path}
  npm install &>>${log_file}

  echo -e "${color}Setup systemd ${component} service${no_color}"
  cp /home/centos/roboshop1-shell/${component}.service /etc/systemd/system/${component}.service   &>>${log_file}

  echo -e "${color}Start ${component} service${no_color}"
  systemctl daemon-reload   &>>${log_file}
  systemctl enable ${component}    &>>${log_file}
  systemctl restart ${component}     &>>${log_file}
}

func_mongodb() {
  echo -e "${color}Setup mongoDB repo${no_color}"
  cp /home/centos/roboshop1-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>${log_file}

  echo -e "${color}Install Mongodb client${no_color}"
  dnf install mongodb-org-shell -y    &>>${log_file}

  echo -e "${color}Load schema${no_color}"
  mongo --host mongodb-dev.smitdevops.online <${app_path}/schema/${component}.js    &>>${log_file}
}

func_mysql() {
  echo -e "${color}Install mysql client${no_color}"
  dnf install mysql -y    &>>${log_file}

  echo -e "${color}Install mysql client${no_color}"
  mysql -h mysql-dev.smitdevops.online -uroot -pRoboShop@1 <${app_path}/schema/${component}.sql   &>>${log_file}
}

func_maven() {
  echo -e "${color}Install maven${no_color}"
  dnf install maven -y    &>>${log_file}

  echo -e "${color}Add application User${no_color}"
  useradd roboshop    &>>${log_file}

  echo -e "${color}Setup an app directory${no_color}"
  rm -rf ${app_path}   &>>${log_file}
  mkdir ${app_path}    &>>${log_file}

  echo -e "${color}Download the application code & unzip to created app directory${no_color}"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip   &>>${log_file}
  cd ${app_path}
  unzip /tmp/${component}.zip   &>>${log_file}

  echo -e "${color}Download the dependencies & build the application${no_color}"
  mvn clean package   &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar   &>>${log_file}

  echo -e "${color}Setup SystemD ${component} Service${no_color}"
  cp /home/centos/roboshop1-shell/${component}.service /etc/systemd/system/${component}.service   &>>${log_file}

  func_mysql

  echo -e "${color}Start the service ${no_color}"
  systemctl daemon-reload   &>>${log_file}
  systemctl enable ${component}   &>>${log_file}
  systemctl restart ${component}    &>>${log_file}
}

python() {
  echo -e "${color}Install Python 3.6${no_color}"
  dnf install python36 gcc python3-devel -y   &>>${log_file}

  echo -e "${color}Add application User${no_color}"
  useradd roboshop    &>>${log_file}

  echo -e "${color}setup an app directory${no_color}"
  rm -rf ${app_path}   &>>${log_file}
  mkdir ${app_path}    &>>${log_file}

  echo -e "${color}Download the app code and unzip${no_color}"
  curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip   &>>${log_file}
  cd ${app_path}
  unzip /tmp/payment.zip    &>>${log_file}

  echo -e "${color}Download the dependencies${no_color}"
  pip3.6 install -r requirements.txt    &>>${log_file}

  echo -e "${color}Setup SystemD Payment Service${no_color}"
  cp /home/centos/roboshop1-shell/payment.service /etc/systemd/system/payment.service   &>>${log_file}

  echo -e "${color}Start the service${no_color}"
  systemctl daemon-reload   &>>${log_file}
  systemctl enable payment    &>>${log_file}
  systemctl restart payment   &>>${log_file}
}