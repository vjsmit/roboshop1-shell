echo -e "\e[31m Install Python 3.6 \e[0m"
dnf install python36 gcc python3-devel -y   &>>/tmp/roboshop.log

echo -e "\e[31m Add application User \e[0m"
useradd roboshop    &>>/tmp/roboshop.log

echo -e "\e[31m setup an app directory \e[0m"
rm -rf /app   &>>/tmp/roboshop.log
mkdir /app    &>>/tmp/roboshop.log

echo -e "\e[31m Download the app code and unzip \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip   &>>/tmp/roboshop.log
cd /app
unzip /tmp/payment.zip    &>>/tmp/roboshop.log

echo -e "\e[31m Download the dependencies \e[0m"
pip3.6 install -r requirements.txt    &>>/tmp/roboshop.log

echo -e "\e[31m Setup SystemD Payment Service \e[0m"
cp /home/centos/roboshop1-shell/payment.service /etc/systemd/system/payment.service   &>>/tmp/roboshop.log

echo -e "\e[31m Start the service \e[0m"
systemctl daemon-reload   &>>/tmp/roboshop.log
systemctl enable payment    &>>/tmp/roboshop.log
systemctl restart payment   &>>/tmp/roboshop.log