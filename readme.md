# Getting Started With Vagrant

Vagrant stuffs for the DrupalCamp Leuven [Getting Started With Vagrant](http://leuven2013.drupalcamp.be/session/getting-started-vagrant) 
session.

## Important note on security

This repo is for demonstration purposes only and contains some passwords. 
It's stronlgy recommended to not use the scripts 'as is' for production or even development environments.


## How to use this Vagrant setup

This repo contains two main parts:

[1. provision_box](https://github.com/sjugge/DCL13_Vagrant#provision_box): this box provisions a clean Ubuntu 12.04 Vagrant box.

[2. project_box](https://github.com/sjugge/DCL13_Vagrant#project_box): this box is intended as resource for Drupal projects. 


## [provision_box](https://github.com/sjugge/DCL13_Vagrant/tree/master/provision_box)

Takes an empty precise64 vagrant box and provisions it with a LAMP stack and other tools, aimed at running Drupal.
After provisioning it is packaged so that users don't have to go throught the entire instalation process of the LAMP stack.
The build box is repackaged and made available at https://bitly.com/precise64DCL (links to dropbox) in order to demonstrate the project_box.


### Usage

* `vagrant up`
* `vagrant package --base build_box_TIMESTAMP --output name_of_result.box`
* use the packaged box to run the project_box. This way provisioning only has to run once.

To find out the name of the running Vagrant box (`build_box_TIMESTAMP`), you can run `VBoxManage list vms` to list running Vagrant instances.


## [project_box](https://github.com/sjugge/DCL13_Vagrant/tree/master/project_box)
Provides needed files to run [a Drupal project](https://github.com/sjugge/DCL13_Drupal) on Vagrant.


### Usage

* copy the `Vagrantfile` and `scripts` folder to your Drupal project
  * `cp /path/to/DCL13_Vagrant/project_box/Vagrantfile /path/to/DCL13_Drupal/Vagrantfile`
  * `cp -r /path/to/DCL13_Vagrant/project_box/scripts/* /path/to/DCL13_Drupal/scripts`
* run `vargant up`


## Customisations & hacks

Improvements to this setup can be done by forking, pull requests, posting issues, etc. However, I can't promise any sort of guarantee that these will be adressed in a timely fashion.
You are ofcourse free to clone the repo and improve or alter it to fit your needs.

## Known issues

Things that aren't completely up to par are likely to be logged in [the issue tracker](https://github.com/sjugge/DCL13_Vagrant/issues).

