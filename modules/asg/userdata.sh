#!/bin/bash
apt-get update

sed -i '172s/.*/        AllowOverride All/' /etc/apache2/apache2.conf
service apache2 restart
aws s3 cp s3://demo-testing-drupal/drupal-testing.tar drupal-testing.tar
tar -xvf drupal-testing.tar
mv drupal /var/www/html/drupal
sudo sed -i "/\*/! s/'host' => .*/'host' => '${rds_endpt}',/g" /var/www/html/drupal/sites/default/settings.php
chown -R www-data:www-data /var/www/html/drupal/
chmod -R 755 /var/www/html/drupal/
service apache2 restart
echo $? >> /home/ubuntu/testing.txt
systemctl restart varnish
