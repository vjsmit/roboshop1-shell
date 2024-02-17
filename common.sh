color="\e[32m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

app_presetup() {
  echo -e "${color}Adding App user${no_color}"
  useradd roboshop    &>>${log_file}
  echo $?

  echo -e "${color}Create App Dir${no_color}"
  rm -rf ${app_path}
  mkdir ${app_path}
  echo $?

  echo -e "${color}Downloading App Code${no_color}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip    &>>${log_file}
  echo $?

  echo -e "${color}Unzip App Code${no_color}"
  cd ${app_path}
  unzip /tmp/${component}.zip    &>>${log_file}
  echo $?

}

func_systemd() {
  echo -e "${color}Setup SystemD ${component} Service${no_color}"
  cp /home/centos/roboshop1-shell/${component}.service /etc/systemd/system/${component}.service   &>>${log_file}
  echo $?

  echo -e "${color}Start ${component} service${no_color}"
  systemctl daemon-reload   &>>${log_file}
  systemctl enable ${component}    &>>${log_file}
  systemctl restart ${component}     &>>${log_file}
  echo $?
}


func_nodejs() {
  echo -e "${color}Disabling Default nodejs${no_color}"
  dnf module disable nodejs -y    &>>${log_file}

  echo -e "${color}Enable nodejs 18 version${no_color}"
  dnf module enable nodejs:18 -y    &>>${log_file}

  echo -e "${color}Installing nodejs${no_color}"
  dnf install nodejs -y   &>>${log_file}

  app_presetup

  echo -e "${color}Download dependencies${no_color}"
  cd ${app_path}
  npm install &>>${log_file}

  func_systemd
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

  echo -e "${color}Load Schema${no_color}"
  mysql -h mysql-dev.smitdevops.online -uroot -pRoboShop@1 <${app_path}/schema/${component}.sql   &>>${log_file}
}

func_maven() {
  echo -e "${color}Install maven${no_color}"
  dnf install maven -y    &>>${log_file}

  app_presetup

  echo -e "${color}Download the dependencies & build the application${no_color}"
  mvn clean package   &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar   &>>${log_file}

  func_mysql

  func_systemd
}

python() {
  echo -e "${color}Install Python 3.6${no_color}"
  dnf install python36 gcc python3-devel -y   &>>${log_file}
  if [$? == 0]; then
    echo SUCCESS
  else
    echo FAILURE
  fi
  app_presetup

  echo -e "${color}Download the dependencies${no_color}"
  pip3.6 install -r requirements.txt    &>>${log_file}
  echo $?

  func_systemd
}

func_golang() {
  echo -e "${color}Install GoLang${no_color}"
  dnf install golang -y   &>>${log_file}

  app_presetup

  echo -e "${color}Download the dependencies${no_color}"
  go mod init dispatch    &>>${log_file}
  go get    &>>${log_file}
  go build    &>>${log_file}

  func_systemd
}