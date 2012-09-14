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

provides "linux/ladvd"

unless %x[which ladvdc].eql?("")

  ladvd_info = %x[ladvdc -b]

  unless ladvd_info.eql?("")

    ladvd Mash.new

    capabilities = {
      "r" => "Repeater",
      "B" => "Bridge",
      "H" => "Host",
      "R" => "Router",
      "S" => "Switch",
      "W" => "WLAN Access Point",
      "C" => "DOCSIS Device",
      "T" => "Telephone",
      "O" => "Other"
    }

    ladvd_info = ladvd_info.split("\n")

    index = -1

    ladvd_info.each do |element|

      key,value = element.split("=")
      value.gsub!("'","")
      key.downcase!

      if key.include?("interface")
        index += 1
        ladvd["interface#{index}"] = {}
      end

      key.gsub!("#{index}","")

      if key.eql?("capabilities")
        value = capabilities["#{value}"]
      end

      ladvd["interface#{index}"]["#{key}"] = value
    end
  end
end
