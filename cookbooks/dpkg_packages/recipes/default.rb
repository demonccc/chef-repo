#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: dpkg_packages
# Recipe:: default
#
# Copyright 2012, Claudio Cesar Sanchez Tejeda
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

pkgs = {}

f=file "/var/lib/apt/periodic/update-success-stamp" do
  action :nothing
  not_if { node[:platform_version] < "6.0" } 
end

if node['dpkg_packages']['data_bag']
  node['dpkg_packages']['data_bag']['items'].each do |data_item|
    db_pkgs = begin 
      data_bag_item(node['dpkg_packages']['data_bag']['name'], data_item)
    rescue => ex
      Chef::Log.info("Data bag #{node['dpkg_packages']['data_bag']['name']} not found (#{ex}), so skipping")
      Hash.new
    end
    pkgs.update(db_pkgs["pkgs"])
  end
end
  
pkgs.update(node['dpkg_packages']['pkgs']) if node['dpkg_packages']['pkgs']

pkgs.each do |name, attrs|
  pkg_action = "install"
  package name do
    ignore_failure true
    case attrs
    when TrueClass
      f.run_action(:delete) unless debian_package_info(name)["installed"]
    when Hash
      pkg_action = attrs["action"] if attrs["action"]

      if attrs["platform_version"]
        operator,value = attrs["platform_version"].split(" ")
        if %w{ < > =< >= = }.include?(operator)
          eval("pkg_action = :nothing unless node[\"platform_version\"] #{operator} \"#{value}\"")
        end
      end
      if pkg_action.eql?("install")
        if attrs["version"]
          f.run_action(:delete) unless debian_package_version(name, attrs["version"])
        else
          f.run_action(:delete) unless debian_package_info(name)["installed"]
        end
      end
      %w{version source options}.each do |attr|
        send(attr, attrs[attr])  if attrs[attr]
      end
    else
      pkg_action = :nothing
    end
    action pkg_action
  end
end

if node["dpkg"]
  ohai "reload_dpkg" do
    action :reload
    plugin "dpkg"
  end
end
