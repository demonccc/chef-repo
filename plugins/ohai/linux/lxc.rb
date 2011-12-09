#
# Authors:: Jorge Espada (<espada.jorge@gmail.com>), Claudio Sanchez (<demonccc@gmail.com>)
# 
# License:: Apache License, Version 2.0
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

# You can place it under /etc/ohai/plugins/linux/
# remember to modify /etc/chef/client.rb


# Detect Linux lxc-container                                                                                                                                                                        
provides "linux/lxc_virtualization"
require_plugin "virtualization"

if File.exists?("/proc/1/cpuset")
  proc_cpuset = File.read("/proc/1/cpuset")
  if proc_cpuset.eql?("/\n") && File.directory?("/var/lib/lxc")
    virtualization[:system] = "linux-lxc"
    virtualization[:role] = "host"
  else
    if File.exist?("/proc/1/environ")
    proc_environ = File.read("/proc/1/environ")
      if proc_environ.match('lxc-start')
        virtualization[:system] = "linux-lxc"
        virtualization[:role] = "guest"
      end
    end
  end
end

#Grab info from the guests containers
if virtualization[:system] == "linux-lxc" && virtualization[:role] == "host"
   virtualization[:lxc] = Mash.new
  #created containers
  lxc_guests = %x{lxc-ls}.split.uniq
  #Running continers
  lxc_running =  %x{netstat -xa | grep /var/lib/lxc | awk '{print $9}'}.split.each {|g| g.gsub!("@/var/lib/lxc/","").gsub!("/command","")}

  virtualization[:lxc][:guests] = {}
  lxc_guests.each do |g|
    virtualization[:lxc][:guests]["#{g}"] = {}
    virtualization[:lxc][:guests]["#{g}"]["running"] = "no"
   end
    lxc_running.each do |r|
      virtualization[:lxc][:guests]["#{r}"]["running"] = "yes"
    end
end
