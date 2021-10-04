#!/bin/bash
sudo apt-get update -y
sudo apt-get install apache2 -y
sudo service apache2 start
sudo chkconfig apache2 on

sudo touch /var/www/html/index.html
sudo chown ubuntu /var/www/html/index.html
sudo echo "<html><h1>DZ 15.2</h1><br><br><h2>Host: $(hostname)</h2><br><br><img src="${file}"></html>" > /var/www/html/index.html
sudo wget https://${url}/${file} -P /var/www/html/