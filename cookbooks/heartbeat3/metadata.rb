maintainer        "Claudio Cesar Sanchez Tejeda"
maintainer_email  "demonccc@gmail.com"
license           "Apache 2.0"
description       "Installs and configures heartbeat"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.4.3"

recipe "heartbeat3", "Installs and configures heartbeat"
recipe "heartbeat3::services", "Sanitizes the chef service commands of the services owned by Heartbeat"

%w{ debian ubuntu }.each do |os|
  supports os
end
