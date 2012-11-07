maintainer        "Claudio Cesar Sanchez Tejeda"
maintainer_email  "demonccc@gmail.com"
license           "Apache 2.0"
description       "Installs and configures spamassassin"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.1"

recipe "spamassassin", "Installs and configures spamassassin"

%w{ debian ubuntu }.each do |os|
  supports os
end
