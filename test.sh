#!/bin/bash   

echo "Iniciando teste"
MD5SUM="$(md5sum /etc/apt/sources.list)"
echo $MD5SUM
TOBEMD5="5082e95844d806f092ff808d7839fc98  /etc/apt/sources.list
"
echo "md5 esperado $TOBEMD5 \nmd5 recebido $MD5SUM"


if [ "$TOBEMD5" == "$MD5SUM" ] 
then
 echo "equal"
else 
    echo "not equal"
fi

