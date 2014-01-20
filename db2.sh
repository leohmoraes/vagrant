#!/usr/bin/env bash


#####################################
MD5SUM="$(md5sum /etc/apt/sources.list)"
TOBEMD5="5adc79eaa166bea80eca73d8979fc6f8  /etc/apt/sources.list"
#####################################



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


apt-get update
apt-get install -y -q db2exc
