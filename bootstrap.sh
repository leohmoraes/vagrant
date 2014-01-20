#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
mkdir /projects

#atualiza as listas de pacotes
apt-get update

#configurações do phpmyadmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections

#instala o servidor
apt-get install -y -q apache2 php5 php5-cli mysql-client mysql-server php5-mysql 

apt-get install -y -q phpmyadmin 
#instala softwares adicionais
apt-get install -y -q git lynx

#seta a senha de root
mysqladmin -u root password root

#configura o apache2
rm -rf /etc/apache2/mods-enabled/rewrite.load
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/
ln -s /vagrant/sites-enabled-default /etc/apache2/sites-enabled/sites
rm -rf /var/www
ln -s /projects /var/www
echo '127.0.0.1     ack-default' >> /etc/hosts


#configura o projeto do ack_default
cd /projects/ack_default && php composer.phar self-update && php composer.phar install && php composer.phar update && cd -
cd /projects/ack_default/public && cp .htaccess.frontend .htaccess

apache2ctl restart
service mysql restart
apt-get install phpmyadmin --reinstall
