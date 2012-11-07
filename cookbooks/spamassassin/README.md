# Description

Installs and configures spamassassin

# Requirements

## Chef

Tested on 0.10.8 but newer and older version should work just fine.

## Platform

The following platforms have been tested with this cookbook, meaning that the
recipes run on these platforms without error:

* ubuntu
* debian

## Cookbooks

There are **no** external cookbook dependencies. 

# Installation

Just place the spamassassin directory in your chef cookbook directory and
upload it to your Chef server.

# Usage

Simply include `recipe[spamassassin]` in the node run_list and customize 
the attributes as your needs.

# Recipes

## default

This recipe installs, configures and starts the spamassassin daemon.

# Attributes

## `node['spamassassin']['enabled']`

Enable and start the spamassassin daemon.

## `node['spamassassin']['daemon_options']`

Set the daemon options.

## `node['spamassassin']['pidfile']`

Set the pidfile.

## `node['spamassassin']['nice_level']

Set the nice level of the daemon. If it is false, the daemon will be started with the default nice level.

## `node['spamassassin']['cron']`

Enable the cron job of the spamassassin service.

# Resources and Providers

There are **none** defined.

# Libraries

There are **none** defined.

# Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make.

# License and Author

Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>

Copyright:: 2012, Claudio Cesar Sanchez Tejeda

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[repo]:         https://github.com/demonccc/chef-repo
[issues]:       https://github.com/demonccc/chef-repo/issues
