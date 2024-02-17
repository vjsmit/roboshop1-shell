source common.sh

echo -e "${color}Installing Nginx${no_color}"
dnf install nginx -y            &>>${log_file}

echo -e "${color}Removing default html content${no_color}"
rm -rf /usr/share/nginx/html/*    &>>${log_file}

echo -e "${color}Download frontend content${no_color}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip   &>>${log_file}

echo -e "${color}Unzip frontend content${no_color}"
cd /usr/share/nginx/html  &>>${log_file}
unzip /tmp/frontend.zip   &>>${log_file}

echo -e "${color}Copy reverse proxy config${no_color}"
cp /home/centos/roboshop1-shell/frontend.conf /etc/nginx/default.d/roboshop.conf  &>>${log_file}


echo -e "${color}Enable and restart nginx server${no_color}"
systemctl enable nginx      &>>${log_file}
systemctl restart nginx     &>>${log_file}

