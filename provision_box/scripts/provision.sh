#! /bin/bash

##### INFO #####

# Provision.sh
#
# This script will provision a clean Vagrant box.
# After provisioning a box, it can be repackaged.
# So that project setup time can be reduced.
#
# Author: Jurgen Verhasselt - https://github.com/sjugge


##### VARIABLES #####

# Throughout this script, some variables are used, these are defined first.
# These variables can be altered to fit your specific needs or preferences.

# Server name
HOSTNAME="vagrant.dcl"

# MySQL password
MYSQL_PASS="root" # can be altered, though storing passwords in a script is a bad idea!

# Locale
LOCALE_LANGUAGE="en_US" # can be altered to your prefered locale, see http://docs.moodle.org/dev/Table_of_locales
LOCALE_CODESET="en_US.UTF-8"

# Timezone
TIMEZONE="Europe/Brussels" # can be altered to your specific timezone, see http://manpages.ubuntu.com/manpages/jaunty/man3/DateTime::TimeZone::Catalog.3pm.html

# Drush
DRUSH_VERSION="5.9.0" # prefered Drush release from https://github.com/drush-ops/drush/releases

#----- end of configurable variables -----#


##### PROVISION CHECK ######

# The provision check is intented to not run the full provision script when a box has already been provisioned.
# At the end of this script, a file is created on the vagrant box, we'll check if it exists now.
echo "[vagrant provisioning] Checking if the box was already provisioned..."

if [ -e "/home/vagrant/.provision_check" ]
then
  # Skipping provisioning if the box is already provisioned
  echo "[vagrant provisioning] The box is already provisioned..."
  exit
fi


##### PROVISION LAMP STACK #####

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
# Upgrades cause a known issue, see https://github.com/sjugge/DCL13_Vagrant/issues/1
# echo "[vagrant provisioning] Updating installed packages..."
# unset UCF_FORCE_CONFFOLD
# export UCF_FORCE_CONFFNEW=YES
# ucf --purge /boot/grub/menu.lst
# export DEBIAN_FRONTEND=noninteractive
# apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade

# Install or update nfs-common to the latest release
echo "[vagrant provisioning] Installing nfs-common..."
sudo apt-get install -y nfs-common # commonly installed on Ubuntu but not on all Linux distros

# Set MySQL root password and install MySQL. Info on unattended install: http://serverfault.com/questions/19367
echo mysql-server mysql-server/root_password select $MYSQL_PASS | debconf-set-selections
echo mysql-server mysql-server/root_password_again select $MYSQL_PASS | debconf-set-selections
echo "[vagrant provisioning] Installing mysql-server and mysql-client..."
sudo apt-get install -y mysql-server mysql-client # install mysql server and client
sudo service mysql restart # restarting for sanities' sake

# Install Apache
echo "[vagrant provisioning] Installing apache2..."
sudo apt-get install -y apache2 # installs apache and some dependencies
sudo service apache2 restart # restarting for sanities' sake
echo "[vagrant provisioning] Applying Apache vhost conf..."
sudo rm -f /etc/apache2/sites-available/default
sudo rm -f /etc/apache2/sites-enabled/000-default
sudo cp /home/vagrant/scripts/resources/default /etc/apache2/sites-available/
sudo ln -s /etc/apache2/sites-available/default /etc/apache2/sites-enabled/000-default
a2enmod rewrite # enable mod_rewrite
a2enmod actions # actions
sudo service apache2 restart

# Install PHP
echo "[vagrant provisioning] Installing PHP..."
sudo apt-get install -y php5 php5-cli php5-common php5-curl php5-gd php5-mysql # php install with common extensions
sudo service apache2 restart # restart apache so latest php config is picked up


##### PROVISION OTHER PACKAGES #####

echo "[vagrant provisioning] Installing other packages..."

# Postfix
echo "[vagrant provisioning] Installing postfix, mailutils..."
echo postfix postfix/mailname string $HOSTNAME | debconf-set-selections
echo postfix postfix/main_mailer_type string 'Internet Site' | debconf-set-selections
sudo apt-get install -y postfix
service postfix reload

# Misc tools
echo "[vagrant provisioning] Installing curl, make, openssl, vim..."
sudo apt-get install -y curl # curl
sudo apt-get install -y make # make is not installed by default believe it or not
sudo apt-get install -y openssl # openssl will allow https connections
sudo apt-get install -y php5-dev # install phep5-dev to get phpize
sudo a2enmod ssl # enable ssl/https
sudo apt-get install -y unzip # unzip .zip files from cli
sudo apt-get install -y vim # Vim, since only the vim-tidy package is installed

# Version control tools
echo "[vagrant provisioning] Installing git, svn..."
sudo apt-get install -y git # GIT, in case you want to control source on the Vagrant instance
sudo apt-get install -y subversion # SVN, since not everyone has hopped over to GIT yet

# Install Drush
echo "[vagrant provisioning] Installing drush..."
sudo wget -q https://github.com/drush-ops/drush/archive/$DRUSH_VERSION.tar.gz # download drush from github
sudo tar -C /opt/ -xzf $DRUSH_VERSION.tar.gz # untar drush in /opt
sudo chown -R vagrant:vagrant /opt/drush-$DRUSH_VERSION # ensure the vagrant user has sufficiënt rights
sudo ln -s /opt/drush-$DRUSH_VERSION/drush /usr/sbin/drush # add drush to /usr/sbin
sudo rm -rf /home/vagrant/$DRUSH_VERSION.tar.gz # remove the downloaded tarbal

# Install xhprof
echo "[vagrant provisioning] Installing xhprof..."
sudo wget -q https://github.com/facebook/xhprof/archive/master.zip
sudo unzip /home/vagrant/master.zip
cd /home/vagrant/xhprof-master/extension
sudo phpize
sudo ./configure
make
make install
echo "extension=xhprof.so" >> /etc/php5/conf.d/xhprof.ini
echo "xhprof.output_dir=/tmp" >> /etc/php5/conf.d/xhprof.ini
cd -
sudo rm -f /home/vagrant/master.zip
sudo service apache2 restart


##### CONFIGURATION #####

echo "[vagrant provisioning] Configuring vagrant box..."
usermod -a -G vagrant www-data # adds vagrant user to www-data group

# Hostname
echo "[vagrant provisioning] Setting hostname..."
sudo hostname $HOSTNAME


##### CLEAN UP #####

sudo dpkg --configure -a # when upgrade or install doesnt run well (e.g. loss of connection) this may resolve quite a few issues
apt-get autoremove -y # remove obsolete packages


##### PROVISION CHECK #####

# Create .provision_check for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check file..."
touch .provision_check
