#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: heartbeat3
# Attributes:: default
#
# Author:: Claudio Cesar Sanchez Tejeda
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

default["heartbeat"]["ha_cf"]["logfacility"] = "local0"
default["heartbeat"]["ha_cf"]["auto_failback"] = "off"
default["heartbeat"]["ha_cf"]["ucast"] = "eth0 1.1.1.1"
default["heartbeat"]["ha_cf"]["node"] = [ "node1", "node2" ]
# Add the services that heartbeat will manage. This cookbook will sanitize them in order to Chef can't start it in the inactive node.
# default["heartbeat"]["services"] = [ 'apache', 'tomcat', 'nginx' ]
default["heartbeat"]["services"] = false
# If you will use pacemaker in order to manage the resources set node["heartbeat"]["haresources"] to false
default["heartbeat"]["haresources"] = false
#default["heartbeat"]["haresources"] = [
#  {
#    "node" => "node1",
#    "resources" => [
#      "IPaddr::135.9.8.7/24/eth0/135.9.8.210",
#      "135.9.216.3/28/eth0/135.9.216.12 httpd",
#      "10.0.0.170 Filesystem::/dev/sda1::/data1::ext2"
#     ]
#  }    
#]
