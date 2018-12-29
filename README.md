# mss-csec.github.io

This repository contains the source code for the MSS CSEC website.

## Requirements

- Ruby 2.4.0
- NodeJS 8.9.3
- Jekyll 3.6.0

## How we build

We use [CircleCI](https://circleci.com) to automate testing, building and
deployment. Using CircleCI instead of GitHub pages is necessary as we implement
some custom build scripts and plugins into this site.

## How to contribute

### Setting up a development environment

The recommended way to build this site is via [Vagrant](https://vagrantup.com).
Once you've downloaded and set up Vagrant, clone this repository to a directory
of your choice, and run

    $ vagrant up

This starts Vagrant and installs the necessary dependencies --- Ruby via RVM,
and NodeJS via NVM.
You can then run `vagrant ssh` to gain SSH access into the VM.
Run `cd /vagrant` to enter the project folder, and start Jekyll with

    $ bundle exec jekyll serve --host 0.0.0.0

The `--host` flag is necessary to be able to access the Jekyll server from the
host machine.
If you're using VirtualBox, you may also have to add the `--watch` and
`--force_polling` flags as file events are not propagated correctly from host to
guest.

If you prefer to not use Vagrant, install the necessary project dependencies
and start Jekyll with

    $ bundle install
    $ npm install
    $ bundle exec jekyll serve

### Suggesting changes

All work is done off of the develop branch. We use a
[git flow](http://nvie.com/posts/a-successful-git-branching-model/)-like
development model, except `master` is replaced with `staging`. So if you wish to contribute, please fork the `develop` branch into a new `feature/*` branch.
The use of `staging` as a base branch instead of `master` is due to the way
GitHub handles organization pages, which necessiates three main branches:

1. `develop`, where main development occurs
2. `staging`, which is the public website pre-build
3. `master`, which hosts the public website

## Contact us

Not really much of a way to do so at the moment. File an issue and we'll try
to get back to you ASAP though.

## Maintainers

### 2017-2018

- Terry Chen (@tyxchen)

### 2018-2019

- &lt;vacant&gt;

