source common.sh
component=dispatch

func_goloang

echo -e "${color}Install GoLang${no_color}"
dnf install golang -y   &>>${log_file}

echo -e "${color}Add application User${no_color}"
useradd roboshop    &>>${log_file}

echo -e "${color}Setup an app directory${no_color}"
rm -rf ${app_path
mkdir ${app_path    &>>${log_file}

echo -e "${color}Download & extract the application code to created app directory${no_color}"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip   &>>${log_file}
cd ${app_path
unzip /tmp/${component}.zip   &>>${log_file}

echo -e "${color}Download the dependencies${no_color}"
go mod init ${component}    &>>${log_file}
go get    &>>${log_file}
go build    &>>${log_file}

echo -e "${color}Setup SystemD Payment Service${no_color}"
cp /home/centos/roboshop1-shell/${component}.service /etc/systemd/system/${component}.service   &>>${log_file}

echo -e "${color}Load the service ${no_color}"
systemctl daemon-reload   &>>${log_file}
systemctl enable ${component}   &>>${log_file}
systemctl restart ${component}    &>>${log_file}

