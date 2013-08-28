#! /bin/bash

# INFO

# Provision.sh
#
# This script will provision a clean Vagrant box.
# After provisioning a box, it can be repackaged.
# So that project setup time can be reduced.
#
# Author: Jurgen Verhasselt - https://github.com/sjugge


#### VARIABLES ####

# Throughout this script, some variables are used, these are defined first.
# These variables can be altered to fit your specific needs or preferences.

# MySQL password
MYSQL_PASS="root" # can be altered, though storing passwords in a script is a bad idea!

# Locale
LOCALE_LANGUAGE="en_US" # can be altered to your prefered locale, see http://docs.moodle.org/dev/Table_of_locales
LOCALE_CODESET="en_US.UTF-8"

# Timezone
TIMEZONE="Europe/Brussels" # can be altered, see http://manpages.ubuntu.com/manpages/jaunty/man3/DateTime::TimeZone::Catalog.3pm.html

#----- end of configurable variables -----#


#### PROVISION LAMP STACK ####

echo "[vagrant provisioning] Installing LAMP stack..."

# Set Locale, see https://help.ubuntu.com/community/Locale#Changing_settings_permanently
echo "[vagrant provisioning] Setting locale..."
sudo locale-gen $LOCALE_LANGUAGE $LOCALE_CODESET

# Set timezone, for unattended info see https://help.ubuntu.com/community/UbuntuTime#Using_the_Command_Line_.28unattended.29
echo "[vagrant provisioning] Setting timezone..."
echo $TIMEZONE | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Download and update package lists
echo "[vagrant provisioning] Package manager updates..."
sudo apt-get update

# Upgrade installed packages. Info on unattended update: http://askubuntu.com/a/262445
echo "[vagrant provisioning] Updating installed packages..."
unset UCF_FORCE_CONFFOLD
export UCF_FORCE_CONFFNEW=YES
ucf --purge /boot/grub/menu.lst
export DEBIAN_FRONTEND=noninteractive
apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade

# Install or update nfs-common to the latest release
echo "[vagrant provisioning] Installing nfs-common..."
sudo apt-get -y install nfs-common # commonly installed on Ubuntu but not on all Linux distros

# Set MySQL root password and install MySQL. Info on unattended install: http://serverfault.com/questions/19367
echo mysql-server mysql-server/root_password select $MYSQL_PASS | debconf-set-selections
echo mysql-server mysql-server/root_password_again select $MYSQL_PASS | debconf-set-selections
echo "[vagrant provisioning] Installing mysql-server..."
sudo apt-get install -y mysql-server
sudo service mysql restart # restarting for sanities' sake

# Install Apache
echo "[vagrant provisioning] Installing apache2..."
sudo apt-get -y install apache2
sudo service apache2 restart # restarting for sanities' sake

# Install PHP
echo "[vagrant provisioning] Installing PHP..."
sudo apt-get install php5


#### PROVISION OTHER PACKAGES ####

echo "[vagrant provisioning] Installing other packages..."

sudo apt-get -y install openssl # openssl will allow https connections
sudo a2enmod ssl # enable ssl/https
sudo apt-get -y install vim # Vim, since only the vim-tidy package is installed
sudo apt-get -y install git # GIT, in case you want to control source on the Vagrant instance


##### CONFIGURATION #####

echo "[vagrant provisioning] Configuring vagrant box..."
usermod -a -G vagrant www-data # adds vagrant user to www-data group



#### CLEAN UP ####

sudo dpkg --configure -a # when upgrade or install doesnt run well (e.g. loss of connection) this may resolve quite a few issues
apt-get autoremove -y # remove obsolete packages
