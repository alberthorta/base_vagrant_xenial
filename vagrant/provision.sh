#!/usr/bin/env bash
#/bin/sh -q

sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y upgrade
sudo -E apt-get -q -y install php php-cli php-common php-curl php-gd php-json php-mcrypt php-mysql php-readline mysql-server mysql-client libapache2-mod-php apache2 redis-server redis-tools build-essential curl vim libfile-pushd-perl git composer unzip

sudo -E rm -r /var/www
sudo -E ln -s /vagrant /var/www
sudo -E sed -i -e 's/www-data/ubuntu/g' /etc/apache2/envvars
sudo -E rm /etc/apache2/sites-enabled/*
sudo -E cp /vagrant/vagrant/.apache.http.conf /etc/apache2/sites-available/vagrant.conf
sudo -E sed -i -e 's/__HOSTNAME__/${HOSTNAME}/g' /etc/apache2/sites-available/vagrant.conf
sudo -E ln -s /etc/apache2/sites-available/vagrant.conf /etc/apache2/sites-enabled/
sudo -E a2enmod access_compat alias auth_basic authn_core authn_file authz_core authz_host authz_user autoindex deflate dir env expires filter headers mime_prefork negotiation php reqtimeout rewrite setenvif socache_shmcb ssl status
sudo -E apache2ctl graceful
sudo -E mysql -u root -Bse "grant all privileges on ${MYSQL_DB}.* to '${MYSQL_USER}'@'localhost' identified by '${MYSQL_PASSWORD}'; flush privileges; create database ${MYSQL_DB};"

if [ "${SERVICE}" = "wordpress" ]
then
    echo "Installing Wordpress"
    sudo -E cp /vagrant/vagrant/.composer.json.wordpress /var/www/html/composer.json
    sudo -E cp /vagrant/vagrant/.htaccess.wordpress /var/www/html/.htaccess
    sudo -E sed -i -e 's/__HOSTNAME__/${HOSTNAME}/g' /var/www/html/.htaccess
    composer install -d /var/www/html/
    rm /var/www/html/index.php
    sudo -E apache2ctl graceful
fi