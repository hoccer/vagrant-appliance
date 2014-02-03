# Hoccer Vagrant Setup

## Prerequisites

* Vagrant must be installed (the package installer from http://www.vagrantup.com/)
* VirtualBox must be installed (https://www.virtualbox.org/)
* Internet connectivity
* rvm must be installed

Developed and tested on OS X

## Setup

Enter directory and first link up the `.ruby*` files:

<pre>
$ ln -s .ruby-version.dev .ruby-version
$ ln -s .ruby-gemset.dev .ruby-gemset
$ cd . # to activate this setting
</pre>

Then install all required gems via

<pre>
$ bundle
</pre>

Then install all required puppet modules via

<pre>
$ librarian-puppet install --verbose
</pre>


## Usage

Execute in checked out directory:
<pre>
$ vagrant up
</pre>

This should produce an output similar to this:
<pre>
...
</pre>

check if VM is running via
<pre>
$ vagrant status
</pre>

access the VM via
<pre>
$ vagrant ssh
</pre>

Subsequent provisioning can usually happen while the vm is running via
<pre>
$ vagrant provision
</pre>

## Raketasks

Two important rake tasks are provided

* `rake vm:initialize` - Sets up the vm from scratch and takes care of the librarian-puppet modules as well. This task is intended to be executed immediately after checkout to get up and running with a single command.

* `rake vm:provision` - Any changes to modules or manifests can be reflected in a running VM with this task. Takes care of puppet-librarian modules and reprovisioning.

## Notes

This setup uses librarian-puppet to manage the puppet module dependencies (similar to bundler but for puppet modules).

For listing the currently installed modules execute

<pre>
$ librarian-puppet show
</pre>

## Using VM as deployment target

In order to deploy to the VM via a capistrano setup it may be necessary to
add your ssh pubkey to the deployment user's `authorized_keys`

## TODOs

* maybe use rake to make management of vagrant VM simpler

## Updating puppet dependencies

The puppet modules are defined by the Puppetfile and the Puppetfile.lock.
If they are changed the puppet modules should be refreshed.

Ideally by using:

<pre>
$ librarian-puppet clean
$ librarian-puppet install
</pre>
