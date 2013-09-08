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

echo "[vagrant project provisioning] Creating MySQL db & user..."
mysql -u root -e "create database VAGRANT default character set utf8" -proot
mysql -u root -e "grant all privileges on VAGRANT.* to VAGRANT@localhost identified by 'VAGRANT'" -proot
echo "[vagrant project provisioning] Importing latest db..."
LATESTDB=`ls -t /home/vagrant/db | grep .sql | head -1`
mysql -u VAGRANT -pVAGRANT VAGRANT < /home/vagrant/db/$LATESTDB


##### PROJECT PROVISION CHECK #####

# Create .project_provision_check for the script to check on during a next vargant up.
echo "[vagrant project provisioning] Creating .project_provision_check file..."
touch .project_provision_check