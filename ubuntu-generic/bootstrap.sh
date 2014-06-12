#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive


[ ! -d /projects ] && {

	mkdir /projects
	chmod 777 -R /projects

}

#atualiza as listas de pacotes
apt-get update 

apt-get install -y  -q build-essential