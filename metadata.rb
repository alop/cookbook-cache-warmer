name          "cache-warmer"
maintainer    "AT&T Services, Inc"
maintainer_email  "cookbooks@lists.tfoundry.com"
license           "Apache 2.0"
description       "Warms up the glance cache"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"

recipe            "cache-warmer", "warms up glance cache"

%w{ ubuntu }.each do |os|
  supports os
end
