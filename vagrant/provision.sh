#/bin/sh -q

sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y upgrade
sudo -E apt-get -q -y install php php-cli php-common php-curl php-gd php-json php-mcrypt php-mysql php-readline mysql-server mysql-client libapache2-mod-php apache2 redis-server redis-tools build-essential curl vim libfile-pushd-perl git