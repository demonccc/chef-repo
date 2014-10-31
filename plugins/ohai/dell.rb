#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
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
#
# NOTES:
#       The server needs to have installed OMSA (omreport command) and SMBIOS 
# (smbios-sys-info command) applications in order to use this plugin.

Ohai.plugin(:Dell) do
  provides 'dell'
  depends 'virtualization/role','dmi/system/manufacturer'
  %w{ system software remote_access storage }.each do |s|
    provides "dell/#{s}"
  end
  collect_data(:linux) do
    dell Mash.new
    Ohai::Log.debug("Dell: Starting collect_data for linux")
    if is_hw? && is_dell?
      Ohai::Log.debug("Dell:\tSystem is Dell and is HW")
      # System info
      Ohai::Log.debug("Dell:\tCollecting system info")
      dell[:system] = collect_system_info
      # Dell software info
      Ohai::Log.debug("Dell:\tCollecting software info")
      dell[:software] = collect_software_info
      # Remote access information
      Ohai::Log.debug("Dell:\tCollecting remote access info")
      dell[:remote_access] = collect_remote_access_info
      # Storage information
      Ohai::Log.debug("Dell:\tCollecting storage info")
      dell[:storage] = collect_storage_info
    end
  end

  def collect_system_info
    system_attr Mash.new
    smbios_info = %x[smbios-sys-info | awk -F: {'print \$2'}]

    unless  smbios_info.eql?("")
      smbios_info=smbios_info.split("\n")
      smbios_info.collect{|x| x.strip!}
      system_attr[:product_name] = smbios_info[1]
      system_attr[:vendor] = smbios_info[2]
      system_attr[:bios_version] = smbios_info[3]
      system_attr[:system_id] = smbios_info[4]
      system_attr[:service_tag] = smbios_info[5]
      system_attr[:service_express_code] = smbios_info[6]
    end
    system_attr
  end
  def collect_software_info
    software Mash.new
    omreport_info = %x[omreport about]
    unless omreport_info.eql?("")
      # OMSA info
      software[:omsa] = {}
      omreport_info = omreport_info.split("\n")
      omreport_info.each do |element|
        unless element.nil?
          key,value = element.split(" : ")
          unless value.nil?
            key.strip!
            key.downcase!
            key.gsub!(" ", "_")
            software[:omsa]["#{key}"] = value.strip
          end
        end
      end
    end
    software
  end
  def collect_remote_access_info
    remote_access Mash.new
    if dell[:software][:omsa]["version"].eql?("6.4.0")
      remote_access_info = %x[omreport chassis remoteaccess -fmt tbl]

      unless remote_access_info.eql?("")
        remote_access_info = remote_access_info.split("\n")
        section = ""

        remote_access_info.each do |element|
          if element.include?("|") 
            element = element.split("|")
            element.collect{|x| x.strip!}
            element[0].downcase!
            unless element[0].eql?("attribute")
              element[0].gsub!(" ", "_")
              remote_access["#{section}"]["#{element[0]}"] = element[1]
            end
          else
            element.strip!
            unless element.include?("-----") || element.eql?("") || element.eql?("Remote Access Information")
              section = element.gsub(" ", "_")
              section.downcase!
              remote_access["#{section}"] = {}
            end
          end
        end
      end 
    else
      if dell[:software][:omsa]["version"].eql?("6.5.0")
        remote_access_info = %x[omreport chassis remoteaccess]

        unless remote_access_info.eql?("")
          remote_access_info = remote_access_info.split("\n")
          section = ""

          remote_access_info.each do |element|
            if element.include?(" : ")
              element = element.split(" : ")
              element.collect{|x| x.strip!}
              element[0].downcase!
              unless element[0].eql?("attribute")
                element[0].gsub!(" ", "_")
                remote_access["#{section}"]["#{element[0]}"] = element[1]
              end
            else
              element.strip!
              unless element.eql?("") || element.eql?("Remote Access Information")
                section = element.gsub(" ", "_")
                section.downcase!
                remote_access["#{section}"] = {}
              end
            end
          end
        end
      end
      remote_access
    end


  end
  def collect_storage_info
    storage Mash.new
    storage[:controller] = {}

    controller = 0
    run = true
    item = -1
    device = ""

    while run do
      storage_info = %x[omreport storage controller controller=#{controller}]
      if storage_info.include?("Invalid controller value.") || storage_info.empty?
        run = false
      else
        storage[:controller][controller] = {}
        storage_info = storage_info.split("\n")
        storage_info.delete_at(0)
        storage_info.each do |element|
          unless element.empty?
            if element.include?(" : ")
              key, value = element.split(" : ")
              value = "" if value.nil?
              key.strip!
              key.downcase!
              key.gsub!("(", "_")
              key.gsub!(")", "_")
              key.gsub!(" ", "_")
              value.strip!
              if key.eql?("id")
                item += 1
                storage[:controller][controller]["#{device}"][item] = {}
              end
              storage[:controller][controller]["#{device}"][item]["#{key}"] = value
            else
              device = element.downcase
              device.gsub!("(s)", "s")
              device.gsub!("(", "_")
              device.gsub!(")", "_")
              device.gsub!(" ", "_")
              storage[:controller][controller]["#{device}"] = []
              item = -1
            end
          end
        end
      end
      controller += 1
    end
    storage
  end
  def is_hw?
    virtualization.nil? || virtualization[:role].nil? || virtualization[:role].eql?("host")
  end
  def is_dell?
    !dmi.nil? && !dmi[:system].nil? && dmi[:system][:manufacturer].eql?("Dell Inc.")
  end
end
