#!/usr/bin/env bash


# ========================= bootstrap =========================

MAIN_USER="vagrant"
MAIN_USER_HOME="/home/vagrant"

# ======================== END bootstrap =======================


echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

yum -y update

yum -y install wget mlocate vim git

#server settings
yum -y install mysql-server

chkconfig mysqld on
/sbin/service mysqld start

#after the installation run:
#/sbin/service mysqld start && /usr/bin/mysql_secure_installation


#here you could put things that will
#only run once per installation
[ ! -e /etc/firstRun ] && {


    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer

    echo 'export PATH=$PATH:/projects/devil-easy-git' >> /home/vagrant/.bashrc
    echo 'export PATH=$PATH:/projects/personalScripts' >> /home/vagrant/.bashrc

    echo 'source /projects/devil-easy-git/aliases.sh'  >> /home/vagrant/.bashrc

    echo 'alias prj="cd /projects"' >> /home/vagrant/.bashrc
    echo 'alias zftool="/usr/local/zend/bin/php vendor/zendframework/zftool/zf.php"' >> /home/vagrant/.bashrc
    echo 'alias phpunit="php vendor/phpunit/phpunit/phpunit.php"' >> /home/vagrant/.bashrc
    echo 'alias gf="git-facade"' >> /home/vagrant/.bashrc


    echo 'short_open_tag=On' >> /etc/php5/apache2/php.ini

    touch  /etc/firstRun
}

rn -rf /vagrant/ssh/* $MAIN_USER_HOME/.ssh/*
cp -rf /vagrant/ssh/* $MAIN_USER_HOME/.ssh
chown $MAIN_USER -R $MAIN_USER_HOME/.ssh

git config --global user.name "Jean"
git config --global user.email "contato@jeancarlomachado.com.br"

echo "Network addresses:"
ip addr
