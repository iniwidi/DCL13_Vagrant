# Getting Started With Vagrant

Vagrant stuffs for the DrupalCamp Leuven [Getting Started With Vagrant](http://leuven2013.drupalcamp.be/session/getting-started-vagrant) 
session.

## Important note on security

This repo is for demonstration purposes only and contains some passwords. 
It's stronlgy recommended to not use the scripts 'as is' for production or even development environments.

## [provision_box](https://github.com/sjugge/DCL13_Vagrant/tree/master/provision_box)

Takes an empty precise64 vagrant box and provisions it with a LAMP stack and other tools, aimed at running Drupal.
The build box is repackaged and made available at https://bitly.com/precise64DCL (links to dropbox).

### Usage

* `vagrant up`
* `vagrant package --base build_box_TIMESTAMP --output name_of_result.box`
* use the packaged box to run the project_box. This way provisioning only has to run once.

## [project_box](https://github.com/sjugge/DCL13_Vagrant/tree/master/project_box)
Provides needed files to run [a Drupal project](https://github.com/sjugge/DCL13_Drupal) on Vagrant.

### Usage

* copy the `Vagrantfile` and `scripts` folder to your Drupal project
  * `cp /path/to/DCL13_Vagrant/project_box/Vagrantfile /path/to/DCL13_Drupal/Vagrantfile`
  * `cp -r /path/to/DCL13_Vagrant/project_box/scripts/* /path/to/DCL13_Drupal/scripts`

