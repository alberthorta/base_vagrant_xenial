#!/usr/bin/env bash
#/bin/sh -q

sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y upgrade
sudo -E apt-get -q -y install php php-cli php-common php-curl php-gd php-json php-mcrypt php-mysql php-readline mysql-server mysql-client libapache2-mod-php apache2 redis-server redis-tools build-essential curl vim libfile-pushd-perl git composer unzip php-simplexml php-mbstring

sudo -E rm -r /var/www
sudo -E ln -s /vagrant /var/www
sudo -E sed -i -e "s/www-data/${BOX_USER}/g" /etc/apache2/envvars
sudo -E rm /etc/apache2/sites-enabled/*
sudo -E cp /vagrant/vagrant/.apache.http.conf /etc/apache2/sites-available/vagrant.conf
sudo -E sed -i -e "s/__HOSTNAME__/${HOSTNAME}/g" /etc/apache2/sites-available/vagrant.conf
sudo -E ln -s /etc/apache2/sites-available/vagrant.conf /etc/apache2/sites-enabled/
sudo -E a2enmod access_compat alias auth_basic authn_core authn_file authz_core authz_host authz_user autoindex deflate dir env expires filter headers mime_prefork negotiation php reqtimeout rewrite setenvif socache_shmcb ssl status
sudo -E apache2ctl graceful
sudo -E mysql -u root -Bse "grant all privileges on ${MYSQL_DB}.* to '${MYSQL_USER}'@'localhost' identified by '${MYSQL_PASSWORD}'; flush privileges; create database ${MYSQL_DB};"

if [ "${SERVICE}" = "wordpress" ]
then
    echo "Installing Wordpress"
    sudo -E cp /vagrant/vagrant/.composer.json.wordpress /var/www/html/composer.json
    sudo -E cp /vagrant/vagrant/.htaccess.wordpress /var/www/html/.htaccess
    cp /vagrant/vagrant/.index.php.wordpress /var/www/html/index.php
    cp /vagrant/vagrant/.wp-config.php.wordpress /var/www/html/wp-config.php
    sudo -E sed -i -e "s/__HOSTNAME__/${HOSTNAME}/g" /var/www/html/.htaccess
    sudo -E sed -i -e "s/__MYSQL_DB__/${MYSQL_DB}/g" /var/www/html/wp-config.php
    sudo -E sed -i -e "s/__MYSQL_USER__/${MYSQL_USER}/g" /var/www/html/wp-config.php
    sudo -E sed -i -e "s/__MYSQL_PASSWORD__/${MYSQL_PASSWORD}/g" /var/www/html/wp-config.php
    composer install -d /var/www/html/
    cp -R /var/www/html/wp/wp-content /var/www/html/
    #INSTALL VISUAL COMPOSER
    unzip -o /vagrant/vagrant/wordpress_plugins/js_composer.5.4.4.zip -d /vagrant/html/wp-content/plugins/
    #INSTALL WPML PLUGINS
    unzip -o "/vagrant/vagrant/wordpress_plugins/wpml-media-translation.2.2.1.zip" -d /vagrant/html/wp-content/plugins/
    unzip -o "/vagrant/vagrant/wordpress_plugins/wpml-string-translation.2.6.3.zip" -d /vagrant/html/wp-content/plugins/
    unzip -o "/vagrant/vagrant/wordpress_plugins/wpml-translation-management.2.4.3.zip" -d /vagrant/html/wp-content/plugins/
    #unzip -o "/vagrant/vagrant/wordpress_plugins/gravityforms-multilingual.1.3.16.zip" -d /vagrant/html/wp-content/plugins/
    #unzip -o "/vagrant/vagrant/wordpress_plugins/acfml.0.6.zip" -d /vagrant/html/wp-content/plugins/
    unzip -o "/vagrant/vagrant/wordpress_plugins/sitepress-multilingual-cms.3.8.4.zip" -d /vagrant/html/wp-content/plugins/
    #unzip -o "/vagrant/vagrant/wordpress_plugins/woocommerce-multilingual.4.2.6.zip" -d /vagrant/html/wp-content/plugins/
    #unzip -o "/vagrant/vagrant/wordpress_plugins/wpml-all-import.2.0.4.zip" -d /vagrant/html/wp-content/plugins/
    unzip -o "/vagrant/vagrant/wordpress_plugins/wpml-cms-nav.1.4.21.zip" -d /vagrant/html/wp-content/plugins/
    unzip -o "/vagrant/vagrant/wordpress_plugins/wpml-sticky-links.1.4.2.zip" -d /vagrant/html/wp-content/plugins/
    rm /vagrant/html/wp-content/plugins/hello.php
    sudo -E service apache2 restart
fi
