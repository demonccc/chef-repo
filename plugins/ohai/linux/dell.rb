#
# Author:: Claudio Cesar Sanchez Tejeda (<demonccc@gmail.com>)
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

provides "dell"

require_plugin "dmi"

unless dell.nil? || !(dmi[:system][:manufacturer].eql?("Dell Inc."))

  # System info

  smbios_info = %x[smbios-sys-info | awk -F: {'print \$2'}]

  unless  smbios_info.eql?("")
    dell[:system] = Mash.new unless dell[:system]
    smbios_info=smbios_info.split("\n")
    smbios_info.collect{|x| x.strip!}
    dell[:system][:product_name] = smbios_info[1]
    dell[:system][:vendor] = smbios_info[2]
    dell[:system][:bios_version] = smbios_info[3]
    dell[:system][:system_id] = smbios_info[4]
    dell[:system][:service_tag] = smbios_info[5]
    dell[:system][:service_express_code] = smbios_info[6]
  end

  # Dell software info

  omreport_info = %x[omreport about]

  unless omreport_info.eql?("")
    dell[:software] = Mash.new unless dell[:software]

    # OMSA info

    dell[:software][:omsa] = {}
    omreport_info = omreport_info.split("\n")
    omreport_info.each do |element|
      unless element.nil?
        key,value = element.split(" : ")
        unless value.nil?
          key.strip!
          key.downcase!
          key.gsub!(" ", "_")
          dell[:software][:omsa]["#{key}"] = value.strip
        end
      end
    end
  end

  # Remote access information

  if dell[:software][:omsa]["version"].eql?("6.4.0")
    remote_access_info = %x[omreport chassis remoteaccess -fmt tbl]

    unless remote_access_info.eql?("")
      remote_access_info = remote_access_info.split("\n")

      dell[:remote_access] = Mash.new unless dell[:remote_access]
      section = ""
 
      remote_access_info.each do |element|
        if element.include?("|") 
          element = element.split("|")
          element.collect{|x| x.strip!}
          element[0].downcase!
          unless element[0].eql?("attribute")
            element[0].gsub!(" ", "_")
            dell[:remote_access]["#{section}"]["#{element[0]}"] = element[1]
          end
        else
          element.strip!
          unless element.include?("-----") || element.eql?("") || element.eql?("Remote Access Information")
            section = element.gsub(" ", "_")
            section.downcase!
            dell[:remote_access]["#{section}"] = {}
          end
        end
      end
    end 
  else
    if dell[:software][:omsa]["version"].eql?("6.5.0")
      remote_access_info = %x[omreport chassis remoteaccess]

      unless remote_access_info.eql?("")
        remote_access_info = remote_access_info.split("\n")

        dell[:remote_access] = Mash.new unless dell[:remote_access]
        section = ""
 
        remote_access_info.each do |element|
          if element.include?(" : ")
            element = element.split(" : ")
            element.collect{|x| x.strip!}
            element[0].downcase!
            unless element[0].eql?("attribute")
              element[0].gsub!(" ", "_")
              dell[:remote_access]["#{section}"]["#{element[0]}"] = element[1]
            end
          else
            element.strip!
            unless element.eql?("") || element.eql?("Remote Access Information")
              section = element.gsub(" ", "_")
              section.downcase!
              dell[:remote_access]["#{section}"] = {}
            end
          end
        end
      end
    end
  end

  # Storage information

  dell[:storage] = Mash.new unless dell[:storage]
  dell[:storage][:controller] = {}

  controller = 0
  run = true
  item = -1
  device = ""

  while run do
    storage_info = %x[omreport storage controller controller=#{controller}]
    if storage_info.include?("Invalid controller value.") || storage_info.empty?
      run = false
    else
      dell[:storage][:controller][controller] = {}
      storage_info = storage_info.split("\n")
      storage_info.delete_at(0)
      storage_info.each do |element|
        unless element.empty?
          if element.include?(" : ")
            key, value = element.split(" : ")
            key.strip!
            key.downcase!
            key.gsub!("(", "_")
            key.gsub!(")", "_")
            key.gsub!(" ", "_")
            value.strip!
            if key.eql?("id")
              item += 1
              dell[:storage][:controller][controller]["#{device}"][item] = {}
            end
            dell[:storage][:controller][controller]["#{device}"][item]["#{key}"] = value
          else
            device = element.downcase
            device.gsub!("(s)", "s")
            device.gsub!("(", "_")
            device.gsub!(")", "_")
            device.gsub!(" ", "_")
            dell[:storage][:controller][controller]["#{device}"] = []
            item = -1
          end
        end
      end
    end
    controller += 1
  end
end
