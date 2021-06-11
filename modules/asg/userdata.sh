#!/bin/bash
apt-get update
mkdir -p /var/www/html
apt-get install nfs-common -y
#Mounting Efs
mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/  /var/www/html
#Making Mount Permanent
echo ${efs_dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | cat >> /etc/fstab
chmod go+rw /var/www/html

apt-get install apache2 -y
apt-get install mysql-client -y
apt-get install mysql-server -y
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install php7.3 libapache2-mod-php7.3 php7.3-cli php7.3-fpm php7.3-json php7.3-common php7.3-mysql php7.3-zip php7.3-gd php7.3-intl php7.3-mbstring php7.3-curl php7.3-xml php7.3-tidy php7.3-soap php7.3-bcmath php7.3-xmlrpc -y
a2enmod proxy_fcgi setenvif
systemctl restart apache2
a2enconf php7.3-fpm
systemctl reload apache2
a2enmod rewrite
systemctl restart apache2
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

apt install varnish -y
systemctl start varnish
systemctl enable varnish
sed -i -e 's/80/8080/g' /etc/apache2/ports.conf
sed -i -e 's/80/8080/g' /etc/apache2/sites-enabled/000-default.conf
systemctl restart apache2
sed -i -e 's/DAEMON_OPTS="-a :6081/DAEMON_OPTS="-a :80/g' /etc/default/varnish
sed -i -e 's/6081/80/g' /lib/systemd/system/varnish.service
systemctl restart apache2
systemctl daemon-reload
systemctl restart varnish
