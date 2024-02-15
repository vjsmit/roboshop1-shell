echo -e "\e[31m Install maven \e[0m"
dnf install maven -y    &>>/tmp/roboshop.log

echo -e "\e[31m Add application User \e[0m"
useradd roboshop    &>>/tmp/roboshop.log

echo -e "\e[31m Setup an app directory \e[0m"
rm -rf /app   &>>/tmp/roboshop.log
mkdir /app    &>>/tmp/roboshop.log

echo -e "\e[31m Download the application code & unzip to created app directory \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip   &>>/tmp/roboshop.log
cd /app
unzip /tmp/shipping.zip   &>>/tmp/roboshop.log

echo -e "\e[31m Download the dependencies & build the application \e[0m"
mvn clean package   &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar   &>>/tmp/roboshop.log

echo -e "\e[31m Setup SystemD Shipping Service \e[0m"
cp /home/centos/roboshop1-shell/shipping.service /etc/systemd/system/shipping.service   &>>/tmp/roboshop.log

echo -e "\e[31m Install mysql client \e[0m"
dnf install mysql -y    &>>/tmp/roboshop.log

echo -e "\e[31m Install mysql client \e[0m"
mysql -h mysql-dev.smitdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql   &>>/tmp/roboshop.log

echo -e "\e[31m Start the service  \e[0m"
systemctl daemon-reload   &>>/tmp/roboshop.log
systemctl enable shipping   &>>/tmp/roboshop.log
systemctl restart shipping    &>>/tmp/roboshop.log
