# == Class: puppet
#
# Install and manage Puppet.
#
# === Parameters
#
# [*puppet_version*]
#   Set the version of Puppet to be installed.
#
# [*hiera_version*]
#   Set the version of hiera to be installed.
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
  $puppet_version = $puppet::params::puppet_version,
  $hiera_version  = $puppet::params::hiera_version,
  $hiera_backend_package = undef,
  $hiera_backend_version = installed,
  $hiera_backend_provider = gem,
) inherits puppet::params {
  package { 'puppet': ensure => $puppet_version }
  package { 'hiera': ensure => $hiera_version }

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
