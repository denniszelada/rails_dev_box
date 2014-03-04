rails-dev-box
=============

A virtual machine for Ruby on Rails and friends.


# How to install it

- Install the puppet modules necessary to provision the virtual machine:

```shell

    $ gem install puppet

    $ gem install librarian-puppet

    $ cd puppet &&  librarian-puppet install

```

- Start the Vagrant VM:

```shell

    $ vagrant up

```
