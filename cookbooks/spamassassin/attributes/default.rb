#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: spamassassin
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

# Daemon options

default["spamassassin"]["enabled"] = false
default["spamassassin"]["daemon_options"] = "--create-prefs --max-children 5 --helper-home-dir"
default["spamassassin"]["pidfile"] = "/var/run/spamd.pid"
default["spamassassin"]["nice_level"] = false
default["spamassassin"]["cron"] = false
