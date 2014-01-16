#!/bin/bash

sudo yum -y update
sudo yum install -y gcc make
sudo yum -y install httpd
sudo service httpd start

sudo /sbin/chkconfig --levels 235 httpd on
sudo service httpd start

echo "<html><body>mark woo</body></html>" > var/www/index.html

