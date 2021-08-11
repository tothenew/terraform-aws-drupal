#!/bin/bash
apt-get update

x=$(echo "${rds_endpt}" | cut -d':' -f1)
mysql -u drupaladmin -predhat22 -h "$x" -e "CREATE DATABASE drupal1; CREATE USER 'drupal1'@'%' IDENTIFIED BY 'drupalpass'; GRANT ALL PRIVILEGES ON drupal1.* TO 'drupal1'@'%'; FLUSH PRIVILEGES;"
sed -i '172s/.*/        AllowOverride All/' /etc/apache2/apache2.conf
service apache2 restart
wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz
tar -xvf drupal.tar.gz
mv drupal-* /var/www/html/drupal
chown -R www-data:www-data /var/www/html/drupal/
chmod -R 755 /var/www/html/drupal/
service apache2 restart
echo $? >> /home/ubuntu/testing.txt
