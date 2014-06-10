#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

php_ini_file="/etc/php5/apache2/php.ini"

[ ! -d /projects ] && {

	mkdir /projects
}

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
apt-get install -y -q git lynx vim

#seta a senha de root
mysqladmin -u root password root

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



#reinicializa os processo
apache2ctl restart
service mysql restart
