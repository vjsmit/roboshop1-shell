echo -e "\e[33m Installing Nginx \e[0m"
dnf install nginx -y

echo -e "\e[33m Removing default html content \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[33m Download frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[33m Unzip frontend content \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[33m Copy reverse proxy config \e[0m"
cp frontend.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[33m Enable and restart nginx server \e[0m"
systemctl enable nginx
systemctl restart nginx