#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: heartbeat3
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

# Disable de services that will be owned by heartbeat

if node["heartbeat"]["services"]
  node["heartbeat"]["services"].each do |srv|
    service srv do
      action :disable
    end
  end
end

# Install the packages

%w{ heartbeat heartbeat-dev }.each do |pkg|
  package pkg do
    action :install
  end
end

# Enable the Heartbeat service

service "heartbeat" do
  supports(
    :restart => true,
    :status => true
  )
  action [ :enable, :start ]
end

# Configure Heartbeat

cookbook_file "/etc/ha.d/authkeys" do 
  source "authkeys"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, "service[heartbeat]"
end 

ha_cf_content = "# File managed by Chef\n# Don't edit it manually!\n"

ha_cf = node['heartbeat']['ha_cf'].sort

ha_cf.each do |k,v|
  if v.is_a?(Array)
    v.each { |x|  ha_cf_content += "\n#{k} #{x}" }
  else
    ha_cf_content += "\n#{k} #{v}" if v
  end
end

file "/etc/ha.d/ha.cf" do
  owner "root" 
  group "root" 
  mode 0644
  content ha_cf_content
  notifies :restart, "service[heartbeat]", :immediately
end

haresources_content = "# File managed by Chef\n# Don't edit it manually!\n\n"

if node['heartbeat']['haresources']

  haresources = node['heartbeat']['haresources'].sort

  haresources.each do |resource_group|
    haresources_content += "#{resource_group['node']}" 
    resource_group['resources'].each do |resource|
      haresources_content += " \\\n        #{resource}"
    end
  end

end
  
file "/etc/ha.d/haresources" do
  owner "root" 
  group "root" 
  mode 0644
  content haresources_content
  notifies :restart, "service[heartbeat]"
end
