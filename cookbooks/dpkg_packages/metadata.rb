maintainer       "Claudio Cesar Sanchez Tejeda"
maintainer_email "demonccc@gmail.com"
license          "Apache 2.0"
description      "Installs deb packages via attributes or data bag metadata."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.3"

supports "ubuntu"
supports "debian"

recipe "dpkg_packages", "Installs/Removes deb packages by reading the instruccions from the node attributes or databags."
