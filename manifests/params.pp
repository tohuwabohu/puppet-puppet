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
  $puppet_package = 'puppet'
  $puppet_provider = undef

  $hiera_version = installed
  $hiera_package = 'hiera'
  $hiera_provider = undef

  $hiera_backend_version = installed
  $hiera_backend_package = undef
  $hiera_backend_provider = gem
}
