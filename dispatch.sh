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
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip   &>>${log_file}
cd ${app_path
unzip /tmp/dispatch.zip   &>>${log_file}

echo -e "${color}Download the dependencies${no_color}"
go mod init dispatch    &>>${log_file}
go get    &>>${log_file}
go build    &>>${log_file}

echo -e "${color}Setup SystemD Payment Service${no_color}"
cp /home/centos/roboshop1-shell/dispatch.service /etc/systemd/system/dispatch.service   &>>${log_file}

echo -e "${color}Load the service ${no_color}"
systemctl daemon-reload   &>>${log_file}
systemctl enable dispatch   &>>${log_file}
systemctl restart dispatch    &>>${log_file}

