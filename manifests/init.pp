# == Class: puppet
#
# Install and manage Puppet.
#
# === Parameters
#
# [*ensure*]
#   Set the version of Puppet to be installed.
#
# [*hiera_backend_package*]
#   Set the name of the hiera backend to be installed
#
# [*hiera_backend_version*]
#   Set the version of the hiera backend
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class puppet (
  $ensure = installed,
  $hiera_backend_package = undef,
  $hiera_backend_version = installed,
  $hiera_backend_provider = gem,
) {
  package { 'puppet': ensure => $ensure }

  if $hiera_backend_package != undef {
    package { 'rubygems': ensure => latest }

    package { $hiera_backend_package:
      ensure   => $hiera_backend_version,
      provider => $hiera_backend_provider,
      require  => Package['rubygems'],
    }
  }

  file { ['/var/cache/puppet', '/var/cache/puppet/archives']: ensure => directory }
}
