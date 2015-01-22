#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: spamassassin
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

if platform_family?('rhel')
    package "spamassassin"
else
  %w{ spamassassin razor pyzor spamc }.each do |pkg|
    package pkg
  end
end

service "spamassassin" do
  action node["spamassassin"]["enabled"] ? [:enable, :start] : [ :disable, :stop ]
end

template "/etc/default/spamassassin" do
  mode 0644
  owner "root"
  group "root"
  if node["spamassassin"]["enabled"]
    notifies :restart, "service[spamassassin]"
  end
end
