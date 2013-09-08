# Getting Started With Vagrant

Vagrant stuffs for the DrupalCamp Leuven [Getting Started With Vagrant](http://leuven2013.drupalcamp.be/session/getting-started-vagrant) 
session.

* [Important note on security](https://github.com/sjugge/DCL13_Vagrant#important-note-on-security)
* [Dependencies](https://github.com/sjugge/DCL13_Vagrant#dependencies) 
  * [Note to Linux & Windows users](https://github.com/sjugge/DCL13_Vagrant#note-to-linux--windows-users) 
* [How to use this Vagrant setup](https://github.com/sjugge/DCL13_Vagrant#how-to-use-this-vagrant-setup)
  * [Demo setup](https://github.com/sjugge/DCL13_Vagrant#demo-setup)
  * [Provision Box](https://github.com/sjugge/DCL13_Vagrant#provision_box)
  * [Project Box](https://github.com/sjugge/DCL13_Vagrant#project_box)
* [Customisations & hacks](https://github.com/sjugge/DCL13_Vagrant#customisations--hacks)
* [Known issues](https://github.com/sjugge/DCL13_Vagrant#known-issues)
* [Resources](https://github.com/sjugge/DCL13_Vagrant#resources)


## Important note on security

This repo is for demonstration purposes only and contains some passwords. 
It's stronlgy recommended to not use the resources 'as is' for production or even development environments.


## Dependencies

* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://downloads.vagrantup.com/)


### Note to Linux & Windows users

#### Linux

Although this setup should run on Linux, it is untested. Feedback from Linux users is most welcome.


#### Windows

NFS will not work on Windows. This repo uses NFS for optimal performance of shared folders. 
Further info can be found in [the Vagrant documentation](http://docs.vagrantup.com/v2/synced-folders/nfs.html).

I suggest that if you're running Windows, you get yourself a Linux installer asap.


## How to use this Vagrant setup

### Demo setup

``` bash
mkdir DCL13 && cd DCL13 # made a dir to clone the Vagrant & Drupal repo
git clone git@github.com:sjugge/DCL13_Vagrant.git # clone the Vagrant repo
git clone git@github.com:sjugge/DCL13_Drupal.git # clone the Drupal repo
cp DCL13_Vagrant/project_box/Vagrantfile DCL13_Drupal/Vagrantfile # copy the Vagrantfile to the repo
cp -r DCL13_Vagrant/project_box/scripts/* /path/to/DCL13_Drupal/scripts # copy the scripts & recources to the Drupal repo
cd DCL13_Drupal # go to the Drupal repo
vagrant up # 'vagrant up' the Drupal repo
```
 
The above commands will get an existing Drupal project up and running with just the `vagrant up` command.


### Background

This repo contains two main parts:

[1. provision_box](https://github.com/sjugge/DCL13_Vagrant#provision_box): this box provisions a clean Ubuntu 12.04 Vagrant box.

[2. project_box](https://github.com/sjugge/DCL13_Vagrant#project_box): this box is intended as resource for Drupal projects. 


### [provision_box](https://github.com/sjugge/DCL13_Vagrant/tree/master/provision_box)

Takes an empty precise64 vagrant box and provisions it with a LAMP stack and other tools, aimed at running Drupal.
After provisioning it is packaged so that users don't have to go throught the entire instalation process of the LAMP stack.
The build box is repackaged and made available at https://bitly.com/precise64DCL (links to dropbox) in order to demonstrate the project_box.


#### Provision box usage

* `vagrant up`
* `vagrant package --base build_box_TIMESTAMP --output name_of_result.box`
* use the packaged box to run the project_box. This way provisioning only has to run once.

To find out the name of the running Vagrant box (`build_box_TIMESTAMP`), you can run `VBoxManage list vms` to list running Vagrant instances.


### [project_box](https://github.com/sjugge/DCL13_Vagrant/tree/master/project_box)
Provides needed files to run [a Drupal project](https://github.com/sjugge/DCL13_Drupal) on Vagrant.


#### Project box usage

[See also above...](https://github.com/sjugge/DCL13_Vagrant#demo-setup)

* copy the `Vagrantfile` and `scripts` folder to your Drupal project
  * `cp /path/to/DCL13_Vagrant/project_box/Vagrantfile /path/to/DCL13_Drupal/Vagrantfile`
  * `cp -r /path/to/DCL13_Vagrant/project_box/scripts/* /path/to/DCL13_Drupal/scripts`
* run `vargant up`
 


## Customisations & hacks

Improvements to this setup can be done by forking, pull requests, posting issues, etc. However, I can't promise any sort of guarantee that these will be adressed in a timely fashion.
You are ofcourse free to clone the repo and improve or alter it to fit your needs.


## Known issues

Things that aren't completely up to par are likely to be logged in [the issue tracker](https://github.com/sjugge/DCL13_Vagrant/issues).


## Resources

* [Drupalcamp Leuven session page](http://leuven2013.drupalcamp.be/node/153)
* [Vagrant docs](http://docs.vagrantup.com/)
* [Drupal test repo](https://github.com/sjugge/DCL13_Drupal)
