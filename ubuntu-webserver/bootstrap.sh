#!/usr/bin/env bash

# ========================= bootstrap =========================
    
export DEBIAN_FRONTEND=noninteractive
MAIN_USER="vagrant"
MAIN_USER_HOME="/home/vagrant"

# ======================== END bootstrap =======================


php_ini_file="/etc/php5/apache2/php.ini"

[ ! -d /projects ] && {

	mkdir /projects
	chmod 777 -R /projects
}

apt-get update 
sudo apt-get -y -q install python-software-properties

#configurações do phpmyadmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections

#install php packages
apt-get install -y -q apache2 php5 php5-common php5-mysqlnd php5-xmlrpc php5-curl php5-gd php5-cli  php-pear php5-dev php5-imap php5-mcrypt
#intall the webserver core packages
apt-get install -y -q  mysql-client mysql-server mongodb

#install dependencies to build with pecl
apt-get install -y  -q build-essential python-dev  libldap2-dev libsasl2-dev libssl-dev

#install mongo driver for php
yes |  sudo pecl install mongo

touch /etc/php5/apache2/conf.d/mongo.ini
echo "extension=mongo.so" > /etc/php5/apache2/conf.d/mongo.ini

apt-get install -y -q phpmyadmin 

#aditional useful packages
apt-get install -y -q git vim aptitude

mysqladmin -u root password root	

#import databases on /projects/database folder
[ -e /projects/devil-database-utilities/database-setup-folder ] && {
	/projects/devil-database-utilities/database-setup-folder -v /projects/databases
}

#set cron to export the databases hourly
echo "0 * * * * root /projects/devil-database-utilities/databases-save -v /projects/databases" > /tmp/cron-save-database

crontab /tmp/cron-save-database

rm  -rf /etc/apache2/sites-enabled/*


[ ! -e /etc/apache2/sites-enabled/virtual.conf ] && {

	ln -s /vagrant/vhosts.conf /etc/apache2/sites-enabled/virtual.conf
}
	
[ -e /etc/hosts.bkp ] && {
	mv -f /etc/hosts.bkp /etc/hosts
}

cat /vagrant/hosts >> /etc/hosts
cp /etc/hosts /etc/hosts.bkp


#enables mod rewrite
[ ! -e  /etc/apache2/mods-enabled/rewrite.load ] && {

	ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
}

#creates the default website on root 
[ ! -d /projects/tests ] && {

	mkdir /projects/tests
}


[ -e "$php_ini_file.bkp" ] && {
	mv -f "$php_ini_file.bkp" $php_ini_file
}

cat /vagrant/phpini >> $php_ini_file
cp $php_ini_file "$php_ini_file.bkp"


echo "<?php phpinfo(); " > /projects/tests/index.php

update-rc.d apache2 defaults
update-rc.d mysql defaults
update-rc.d mongodb defaults


sudo apache2ctl restart
service mysql restart


#here you could put things that will
#only run once per installation
[ ! -e /etc/firstRun ] && {

	echo 'export PATH=$PATH:/projects/devil-easy-git' >> /home/vagrant/.bashrc 
	echo 'export PATH=$PATH:/projects/personalScripts' >> /home/vagrant/.bashrc

	touch  /etc/firstRun
}

rn -rf /vagrant/ssh/* $MAIN_USER_HOME/.ssh/*
cp -rf /vagrant/ssh/* $MAIN_USER_HOME/.ssh

chown $MAIN_USER -R $MAIN_USER_HOME/.ssh

su -c "git config --global user.name Jean" -s  /bin/sh vagrant
su -c "git config --global user.email contato@jeancarlomachado.com.br" -s  /bin/sh vagrant

echo "Network addresses:"
ip addr
