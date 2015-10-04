# = Class: puppet::install
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
class puppet::install inherits puppet {
  $real_puppet_packages = any2array($puppet::puppet_packages)

  package { $real_puppet_packages:
    ensure   => $puppet::puppet_ensure,
    provider => $puppet::puppet_provider,
  }

  package { $puppet::hiera_package:
    ensure   => $puppet::hiera_ensure,
    provider => $puppet::hiera_provider,
  }

  if $puppet::hiera_backend_package != undef {
    package { $puppet::hiera_backend_package:
      ensure   => $puppet::hiera_backend_ensure,
      provider => $puppet::hiera_backend_provider,
    }
  }
}
