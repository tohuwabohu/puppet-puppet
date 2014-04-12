# == Class: puppet::params
#
# Default values of the puppet class.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class puppet::params {
  $puppet_version = installed
  $puppet_package = $::operatingsystem ? {
    default => 'package',
  }
  $puppet_provider = $::operatingsystem ? {
    default => undef,
  }

  $hiera_version = installed
}
