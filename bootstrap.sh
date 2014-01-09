#!/usr/bin/env bash


#####################################
MD5SUM="$(md5sum /etc/apt/sources.list)"
TOBEMD5="5adc79eaa166bea80eca73d8979fc6f8  /etc/apt/sources.list"
#####################################

export DEBIAN_FRONTEND=noninteractive

mkdir /projects


#adiciona os repositórios de parceiros
#utilizado no: DB2

echo "md5 esperado $TOBEMD5 \nmd5 recebido $MD5SUM"


if [ "$TOBEMD5" == "$MD5SUM" ] 
then
    echo "pulando processo de adicionar o repositório"
else 
                
    echo "adiconando repositórios do db2"
 echo "
#repositorio para o db2
deb http://archive.canonical.com/ubuntu precise partner 
deb-src http://archive.canonical.com/ubuntu precise partner " >> /etc/apt/sources.list
fi

#atualiza as listas de pacotes
apt-get update

#configurações do phpmyadmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections

#instala o servidor
apt-get install -y -q apache2 php5 php5-cli mysql-client mysql-server php5-mysql db2exc

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
