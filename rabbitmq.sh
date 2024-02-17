echo -e "\e[31m Configure YUM Repos for erlang \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash   &>>/tmp/roboshop.log

echo -e "\e[31m Configure YUM Repos for rabbitmq \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash    &>>/tmp/roboshop.log

echo -e "\e[31m Install RabbitMQ \e[0m"
dnf install rabbitmq-server -y    &>>/tmp/roboshop.log

echo -e "\e[31m Start RabbitMQ Service \e[0m"
systemctl enable rabbitmq-server    &>>/tmp/roboshop.log
systemctl restart rabbitmq-server   &>>/tmp/roboshop.log

echo -e "\e[31m Add one user & set permission \e[0m"
rabbitmqctl add_user roboshop $1   &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"    &>>/tmp/roboshop.log