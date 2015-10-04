# = Class: puppet_masterless::install
#
# Manage the Puppet packages.
#
# == Author
#
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2015 Martin Meinhold, unless otherwise noted.
#
class puppet_masterless::install inherits puppet_masterless {
  $real_puppet_packages = any2array($puppet_masterless::puppet_packages)

  package { $real_puppet_packages:
    ensure   => $puppet_masterless::puppet_ensure,
    provider => $puppet_masterless::puppet_provider,
  }

  package { $puppet_masterless::hiera_package:
    ensure   => $puppet_masterless::hiera_ensure,
    provider => $puppet_masterless::hiera_provider,
  }

  if $puppet_masterless::hiera_backend_package != undef {
    package { $puppet_masterless::hiera_backend_package:
      ensure   => $puppet_masterless::hiera_backend_ensure,
      provider => $puppet_masterless::hiera_backend_provider,
    }
  }
}
