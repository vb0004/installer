#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ubuntu 18.04 dev Server
# Run like - bash install_lamp.sh
# Script should auto terminate on errors

echo -e "\e[96m Adding PPA  \e[39m"
sudo add-apt-repository -y ppa:ondrej/apache2
sudo add-apt-repository -y ppa:ondrej/php
#sudo apt-get update

echo -e "\e[96m Installing apache  \e[39m"
sudo apt-get -y install apache2

echo -e "\e[96m Installing php  \e[39m"
sudo apt-get -y install php7.2 libapache2-mod-php7.2 

# Install some php exts
sudo apt-get -y install curl php7.2-mysql php7.2-curl php7.2-json php7.2-mbstring php7.2-gd php7.2-intl php7.2-xml php7.2-zip php-gettext php7.2-pgsql 
#sudo apt-get -y install php-xdebug
sudo phpenmod curl

# Enable some apache modules
sudo a2enmod rewrite
sudo a2enmod ssl
#sudo a2enmod headers
#sudo a2enmod gzip

echo -e "\e[96m Restart apache server to reflect changes  \e[39m"
sudo service apache2 restart

echo -e "\e[96m Installing mysql server \e[39m"
echo -e "\e[93m User: root, Password: root \e[39m"

# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
echo "mysql-server-5.7 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password root" | sudo debconf-set-selections
sudo apt-get -y install mysql-server-5.7

### Run next command on production server
#sudo mysql_secure_installation

# Download and install composer 
echo -e "\e[96m Installing composer \e[39m"
# Notice: Still using the good old way
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
# Add this line to your .bash_profile
# export PATH=~/.composer/vendor/bin:$PATH

# Check php version
php -v

# Check apache version
apachectl -v

# Check mysql version
mysql --version

# Check if php is working or not
php -r 'echo "\nYour PHP installation is working fine.\n";'

# Fix composer folder permissions
sudo chown -R $USER $HOME/.composer

# Check composer version
composer --version

echo -e "\e[92m Open http://localhost/ to check if apache is working or not. \e[39m"

# Clean up cache
sudo apt-get clean

