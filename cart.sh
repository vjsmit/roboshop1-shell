source=common.sh

echo -e "${color}Disabling Default nodejs${no_color}"
dnf module disable nodejs -y    &>>${log_file}

echo -e "${color}Enable nodejs 18 version${no_color}"
dnf module enable nodejs:18 -y    &>>${log_file}

echo -e "${color}Installing nodejs${no_color}"
dnf install nodejs -y   &>>${log_file}

echo -e "${color}Adding roboshop cart${no_color}"
useradd roboshop    &>>${log_file}

echo -e "${color}Create App Dir${no_color}"
rm -rf ${app_path}
mkdir ${app_path}

echo -e "${color}Downloading App Code\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip    &>>${log_file}

echo -e "${color}Unzip App Code${no_color}"
cd ${app_path}
unzip /tmp/cart.zip    &>>${log_file}

echo -e "${color}Download dependencies${no_color}"
cd ${app_path}
npm install &>>${log_file}

echo -e "${color}Setup systemd cart service${no_color}"
cp /home/centos/roboshop1-shell/cart.service /etc/systemd/system/cart.service   &>>${log_file}


echo -e "${color}Start cart service${no_color}"
systemctl daemon-reload   &>>${log_file}
systemctl enable cart    &>>${log_file}
systemctl restart cart     &>>${log_file}