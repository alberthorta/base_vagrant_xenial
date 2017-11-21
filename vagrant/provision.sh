#/bin/sh -q

sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y upgrade
sudo -E apt-get -q -y install php php-cli php-common php-curl php-gd php-json php-mcrypt php-mysql php-readline mysql-server mysql-client libapache2-mod-php apache2 redis-server redis-tools build-essential curl vim libfile-pushd-perl git

sudo -E rm -r /var/www
sudo -E ln -s /vagrant /var/www
sudo -E sed -i -e 's/www-data/vagrant/g' /etc/apache2/envvars
sudo rm /etc/apache2/sites-enabled/*
sudo cp /vagrant/vagrant/.apache.http.conf /etc/apache2/sites-available/vagrant.conf
sudo ln -s /etc/apache2/sites-available/vagrant.conf /etc/apache2/sites-enabled/
sudo a2enmod access_compat alias auth_basic authn_core authn_file authz_core authz_host authz_user autoindex deflate dir env expires filter headers mime_prefork negotiation php reqtimeout rewrite setenvif socache_shmcb ssl status
sudo apache2ctl graceful
sudo mysql -u root -Bse "grant all privileges on ${MYSQL_DB}.* to '${MYSQL_USER}'@'localhost' identified by '${MYSQL_PASSWORD}'; flush privileges; create database ${MYSQL_DB};"

if [ "${SERVICE}" = "wordpress" ]
then
    echo "Installing Wordpress"
    wget "https://wordpress.org/wordpress-${VERSION}.tar.gz" -P /tmp
    tar xfvz wordpress-${VERSION}.tar.gz -C /var/www/html --strip-components=1
fi