#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: heartbeat3
# Recipe:: services
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

# Sanitize the service chef commands 

if node["heartbeat"]["services"]
  node["heartbeat"]["services"].each do |srv|
    service srv do
      case node['platform']
      when "debian"
        provider Chef::Provider::Service::Init::Debian::Debian_Sanitized 
      when "ubuntu"
        provider Chef::Provider::Service::Upstart::Upstart_Sanitized
      when "redhat","centos","scientific","fedora"
        provider Chef::Provider::Service::Init::Redhat::Redhat_Sanitized
      else
        provider Chef::Provider::Service::Init::Init_Sanitized
      end
    end
  end
end
