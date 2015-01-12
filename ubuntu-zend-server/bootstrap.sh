#!/usr/bin/env bash


# ========================= bootstrap =========================

MAIN_USER="vagrant"
MAIN_USER_HOME="/home/vagrant"

# ======================== END bootstrap =======================


echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

ip addr
