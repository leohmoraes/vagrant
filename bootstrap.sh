#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt-get update

#configurações do phpmyadmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections

apt-get install -y -q apache2 php5 php5-cli git mysql-client mysql-server php5-mysql phpmyadmin

mysqladmin -u root password root

#configura o apache2
rm -rf /var/www
ln -fs /projects/ack_default/public /var/www
rm -rf /etc/apache2/mods-enabled/rewrite.load
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/
rm -rf /etc/apache2/sites-enabled/000-default
ln -s /vagrant/sites-enabled-default /etc/apache2/sites-enabled/000-default
rm -rf /etc/apache2/sites-available/default
ln -s /vagrant/sites-enabled-default /etc/apache2/sites-available/default

#configura o projeto do ack_default
cd /projects/ack_default && php composer.phar self-update && php composer.phar install && php composer.phar update && cd -
cd /projects/ack_default/public && cp .htaccess.frontend .htaccess

apache2ctl restart
