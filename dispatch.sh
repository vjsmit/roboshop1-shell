echo -e "\e[31m Install GoLang \e[0m"
dnf install golang -y   &>>/tmp/roboshop.log

echo -e "\e[31m Add application User \e[0m"
useradd roboshop    &>>/tmp/roboshop.log

echo -e "\e[31m Setup an app directory \e[0m"
mkdir /app    &>>/tmp/roboshop.log

echo -e "\e[31m Download & extract the application code to created app directory \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip   &>>/tmp/roboshop.log
cd /app
unzip /tmp/dispatch.zip   &>>/tmp/roboshop.log

echo -e "\e[31m Download the dependencies \e[0m"
go mod init dispatch    &>>/tmp/roboshop.log
go get    &>>/tmp/roboshop.log
go build    &>>/tmp/roboshop.log

echo -e "\e[31m Setup SystemD Payment Service \e[0m"
cp /home/centos/roboshop1-shell/dispatch.service /etc/systemd/system/dispatch.service   &>>/tmp/roboshop.log

echo -e "\e[31m Load the service  \e[0m"
systemctl daemon-reload   &>>/tmp/roboshop.log
systemctl enable dispatch   &>>/tmp/roboshop.log
systemctl restart dispatch    &>>/tmp/roboshop.log

