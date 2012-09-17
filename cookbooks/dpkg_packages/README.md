# Description

Installs debian packages via attributes or data bag metadata.

# Requirements

## Chef

Tested on 0.10.8 but newer and older version should work just fine.

## Platform

The following platforms have been tested with this cookbook, meaning that the
recipes run on these platforms without error:

* ubuntu
* debian

## Cookbooks

There are **no** external cookbook dependencies. If you want speedup this 
cookbook funtionality, you can add the [dpkg ohai plugin][dpkg] to your nodes. 

The cookbook will force to the apt cookbook (if it is running in the node)
to perform an apt-update if it tries to install a package. 

# Installation

Just place the dpkg_packages directory in your chef cookbook directory and
upload it to your Chef server.

# Usage

Simply include `recipe[dpkg_packages]` in your run_list and populate the
`node['dpkg_packages']['pkgs']` attribute list.

# Recipes

## default

Processes a list of *pkgs* (which is emtpy by default) to be installed.

Use this recipe when you have a list of packages in
`node['dpkg_packages']['pkgs']`.

To use the databag feature, you should create a data bag (the cookbook uses
`pkgs` by default) with items where are defined what packages will be
processed (the default item is the platform name).

For example:

debian item of the pkgs databag:

    {
      "id"    : "debian",
      "pkgs"  : {
        "rsync": true,
        "acl": true,
        "bzip2": { "action": "install", "options": "--force-yes", "platform_version": "> 6.0" }, 
        "less": true,
        "unzip": true,
        "zip": true,
        "dnsutils": { "version": "1:9.7.3.dfsg-1~squeeze5", "action": "install" },
        "whois": true,
        "iproute": true,
        "tcpdump": true,
        "nmap": false,
        "curl": true,
        "wget": true,
        "ethtool": true,
        "lsb-release": { "action": "install", "options": "--force-yes" },
        "screen": true,
        "gzip": true,
        "tar": true,
        "bash-completion": true,
        "psmisc": true,
        "strace": { "action": "remove" } 
      }
    }

# Attributes

## `pkgs`

A hash of hashes where are defined what packages will be processed on the system. 
The keys of the hash correspond to the packages name, and the hash associated to 
these keys, correspond to the attributes passed to the [package resource][package] 
(action, version, source, options). There is a special attribute (`platform_version`)
that defines if the package will be processed or not, according the 
`node["platform_version"]` attribute. When the key corresponds to a boolean value 
instead a hash, the package will be installed according if it is `true` or `false`.

    node['dpkg_packages']['pkgs'] = {
      "nagios-nrpe-server" => { "action" => :install, "options" => "-y --force-yes", "version" => "2.12-4ubuntu1.11.04.2" },
      "nagios-plugins" => { "action" => :install, "options" => "--force-yes" },
      "nsca" => true,
      "munin-plugins-extra" => true,
      "munin-plugins-core" => { "action" => :install, "platform_version": "> 6.0" }
    }

The default is an empty Hash: `{}`.

## `data_bag`

To install packages defined in a data bag, you should set the following attributes:

  node['dpkg_packages']['data_bag']['name'] = 'DATA_BAG_NAME' 
  node['dpkg_packages']['data_bag']['items'] = %w{ ITEM1 ITEM2 ... ITEMX }

`node['dpkg_packages']['data_bag']['name']` is "pkgs" by default
`node['dpkg_packages']['data_bag']['items']` is an array of strings. Each element 
is a the items id of the databag described above where are defined the packages that 
will be processed.

If you don't want to install packages defined in a data bag, set 
`node['dpkg_packages']['data_bag']` to false:
  
  node['dpkg_packages']['data_bag'] = false

# Resources and Providers

There are **none** defined.

# Libraries

This cookbook provides two useful functions that can be used in a [recipe][recipe] or in a [resource][resource]:

`debian_package_info(package_name)` returns a Hash with info about the package.
`debian_package_version(package_name, package_version)` returns true if the package is 
installed.

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

[dpkg]:		https://github.com/demonccc/chef-repo/blob/master/plugins/ohai/linux/dpkg.rb
[recipe]:	http://wiki.opscode.com/display/chef/Recipes
[resouce]:	http://wiki.opscode.com/display/chef/Resources
[package]:      http://wiki.opscode.com/display/chef/Resources#Resources-Package
[repo]:         https://github.com/demonccc/chef-repo
[issues]:       https://github.com/demonccc/chef-repo/issues
