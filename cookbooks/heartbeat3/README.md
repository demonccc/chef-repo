# Description

Installs and configures heartbeat.

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

Just place the heartbeat directory in your chef cookbook directory and
upload it to your Chef server.

# Usage

Simply add recipe[heartbeat] to the run list of the servers that will integrate 
the heartbeat cluster. You can edit the file file/default/authkeys in order to add 
more security to your heartbeat cluster.

If you will install the services that will be managed by heartbeat with some recipes,
you should add the recipe[heartbeat::services] to the node run list. This recipe 
sanitizes the services in order to they can't started or stopped by the service resource.

This cookbook doesn't have templates, all configuration files are generated dinamically 
depending of the keys and their values of the attributes hashes.

Configuration example:

    node['heartbeat']['ha_cf']['logfacility'] = "local0"
    node['heartbeat']['ha_cf']['auto_failback'] = "off"
    node['heartbeat']['ha_cf']['ucast'] = "eth0 1.1.1.1"
    node['heartbeat"]['ha_cf']['node'] = [ "node1", "node2" ]

    node["heartbeat"]["haresources"] = [
      {
        "node" => "node1",
        "resources" => [
          "IPaddr::135.9.8.7/24/eth0/135.9.8.210",
          "135.9.216.3/28/eth0/135.9.216.12 httpd",
          "10.0.0.170 Filesystem::/dev/sda1::/data1::ext2"
        ]
      }
    ]

Will generate the following /etc/ha.d/ha.cf file:

    logfacility local0
    auto_failback off
    ucast eth0 1.1.1.1
    node node1
    node node2

And the following /etc/ha.d/haresources file:
    node 1 \
            IPaddr::135.9.8.7/24/eth0/135.9.8.210 \
            135.9.216.3/28/eth0/135.9.216.12 httpd \
            10.0.0.170 Filesystem::/dev/sda1::/data1::ext2

# Recipes

## default

Installs and configures Heartbeat according the settings of the node attributes. 
Also it disables de services set in the `node['heartbeat']['services']` attribute.

## services

This recipe will sanitize the services that are set in the `node['heartbeat']['services']` 
attribute in order to Chef doesn't start them in the inactive node. This recipe needs to 
be put before that the recipe that will install and configure the service that will be 
managed by heartbeat.

# Attributes

## `ha_cf`

Hash that contains the parameters of the /etc/ha.d/ha.cf file. If the elements are
arrays, they will be added with the same parameter but with different values.

## `services`

It could be `false` or an array that contains the services that will be managed by heartbeat.

## `haresources`

It could be `false` or it could be an array of hashes with the resources definitions. 
If it is false, the /etc/ha.d/haresources will not be generated.

# Resources and Providers

This cookbook provide some service providers that override some actions in order to them couln't be started by Chef.

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
