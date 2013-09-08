#! /bin/bash

##### INFO #####

# project_setup.sh
#
# This script will run on an initial 'vagrant up'..
# It is used to do Drupal or project specific provisioning.
#
# Author: Jurgen Verhasselt - https://github.com/sjugge


##### PROJECT PROVISION CHECK ######

# The project provision check is intented to not run the full project provision script when a box has already been provisioned.
# At the end of this script, a file is created on the vagrant box, we'll check if it exists now.
echo "[vagrant provisioning] Checking if the box was already project provisioned..."

if [ -e "/home/vagrant/.project_provision_check" ]
then
  # Skipping provisioning if the box is already provisioned
  echo "[vagrant project provisioning] The box is already project provisioned..."
  exit
fi


##### MySQL #####

# Note that the commands below assumes that you have used the default credentials as provided
# in the provision_box' provision.sh script, see https://github.com/sjugge/DCL13_Vagrant/blob/master/provision_box/scripts/provision.sh

echo "[vagrant project provisioning] Creating MySQL db & user..."
mysql -u root -e "create database VAGRANT default character set utf8" -proot
mysql -u root -e "grant all privileges on VAGRANT.* to VAGRANT@localhost identified by 'VAGRANT'" -proot
echo "[vagrant project provisioning] Importing latest db..."
LATESTDB=`ls -t /home/vagrant/db | grep .sql | head -1`
mysql -u VAGRANT -pVAGRANT VAGRANT < /home/vagrant/db/$LATESTDB


##### SETTINGS #####

# If a /sites/default/settings.php file exists, a backup will be made. After that, the Drupal version is detected.
# Depending on the Drupal version, the appropriate settings.php file will be copied from the scripts/resources folder to the Drupal codebase.

D6SETTINGS='/home/vagrant/scripts/resources/drupal_6.settings.php'
D7SETTINGS='/home/vagrant/scripts/resources/drupal_7.settings.php'
SETTINGSPATH='/var/www/sites/default/settings.php'

if [ -e "$SETTINGSPATH" ]
then
  
  echo "[vagrant project provisioning] Settings file already found. Moving current settings file to 'settings.php.backup'..."
  /bin/mv $SETTINGSPATH $SETTINGSPATH.backup

fi

echo "[vagrant project provisioning] Creating settings file..."
# Check which Drupal version is present, so that the correct settings file us used..."
DRVE=`drush -r /var/www status | grep 'Drupal version' | sed 's/.*\([0-9]\)\..*$/\1/'`
if [ "$DRVE" = 7 ]
then 

  echo "[vagrant project provisioning] Found a Drupal 7 website, copying settings file ..."
    mv $D7SETTINGS $SETTINGSPATH

elif [ "$DRVE" = 6 ]
then 

  echo "[vagrant project provisioning] Found a Drupal 6 website, copying settings file ..."
    mv $D6SETTINGS $SETTINGSPATH

fi


##### CACHE & CRON #####

echo "[vagrant project provisioning] Clearing cache & running cron..."
drush cc drush
drush -r /var/www cc all
drush -r /var/www cron


##### PROJECT PROVISION CHECK #####

# Create .project_provision_check for the script to check on during a next vargant up.
echo "[vagrant project provisioning] Creating .project_provision_check file..."
touch .project_provision_check
