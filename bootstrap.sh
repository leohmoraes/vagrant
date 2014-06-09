#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

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
apt-get install -y -q git lynx

#seta a senha de root
mysqladmin -u root password root

#enables mod rewrite
[ ! -e  /etc/apache2/mods-enabled/rewrite.load ] && {

	ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
}

[ ! -e /etc/apache2/sites-enabled/default ] && {

	ln -s /vagrant/vhosts.conf /etc/apache2/sites-enabled/default
}

[ -e /etc/hosts.bkp ] && {
	mv -f /etc/hosts.bkp /etc/hosts
}

echo `cat /vagrant/hosts` >> /etc/hosts
cp /etc/hosts /etc/hosts.bkp

#reinicializa os processo
apache2ctl restart
service mysql restart
