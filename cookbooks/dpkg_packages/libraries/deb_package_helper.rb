#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: dpkg_packages
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
   
module DebPackageHelper

  def debian_package_info(package_name)
    debian_package = { "installed" => false }
    if node["dpkg"] and node["dpkg"][package_name] 
       debian_package["installed"] = true if node["dpkg"][package_name]["status"].eql?("install ok installed")
       debian_package["version"] = node["dpkg"][package_name]["version"]
    else
      status = Chef::Mixin::Command.popen4("dpkg -s #{package_name}") do |pid, stdin, stdout, stderr|
        stdout.each_line do |line|
          case line
          when /^Status: install ok installed/
            debian_package["installed"] = true
          when /^Version: (.+)$/
            if debian_package["installed"]
              debian_package["version"] = $1
            end
          end
        end
      end
    end
    return debian_package
  end

  def debian_package_version(package_name, package_version)
    debian_package = debian_package_info(package_name)
    return true if debian_package["installed"] and debian_package["version"].eql?(package_version)
    return false
  end

end

class Chef::Recipe
  include DebPackageHelper
end

class Chef::Resource
  include DebPackageHelper
end
