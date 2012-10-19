#
# Cookbook Name:: heartbeat3
# Provider:: debian_sanitized
#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Copyright:: Copyright (c) 2012
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


require 'chef/provider'
require 'chef/provider/service'
require 'chef/provider/service/debian'

class Chef
  class Provider
    class Service
      class Debian_Sanitized < Chef::Provider::Service::Init::Debian
  
        def managed_service
          Chef::Log.info("This action couldn't be performed because the service #{@new_resource.service_name} is managed by heartbeat.")
        end

        def enable_service
          managed_service
        end

        def start_service
          managed_service
        end

        def stop_service
          managed_service
        end

        def restart_service
          if @current_resource.running 
            super
          else
            managed_service
          end
        end

        def reload_service
          if @current_resource.running
            super
          else
            managed_service
          end
        end

      end
    end
  end
end
