echo -e "\e[31m disable MySQL 8 version \e[0m"
dnf module disable mysql -y   &>>/tmp/roboshop.log


echo -e "\e[31m Setup the MySQL5.7 repo file \e[0m"
cp /home/centos/roboshop1-shell/mysql.repo /etc/yum.repos.d/mysql.repo      &>>/tmp/roboshop.log

echo -e "\e[31m Install MySQL Server \e[0m"
dnf install mysql-community-server -y   &>>/tmp/roboshop.log

echo -e "\e[31m Start MySQL Service \e[0m"
systemctl enable mysqld   &>>/tmp/roboshop.log
systemctl restart mysqld    &>>/tmp/roboshop.log

echo -e "\e[31m change the default root password \e[0m"
mysql_secure_installation --set-root-pass RoboShop@1    &>>/tmp/roboshop.log