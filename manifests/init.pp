# == Class: puppet
#
# Install and manage Puppet.
#
# === Parameters
#
# [*puppet_version*]
#   Set the version of Puppet to be installed.
#
# [*puppet_package*]
#   Set the name of the package to be installed.
#
# [*puppet_provider*]
#   Set the provider used to install the package.
#
# [*hiera_version*]
#   Set the version of hiera to be installed.
#
# [*hiera_provider*]
#   Set the provider used to install hiera.
#
# [*hiera_backend_version*]
#   Set the version of the hiera backend.
#
# [*hiera_backend_package*]
#   Set the name of the hiera backend to be installed.
#
# [*hiera_backend_provider*]
#   Set the provider used to install the hiera backend package.
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
  $puppet_version         = params_lookup('puppet_version'),
  $puppet_package         = params_lookup('puppet_package'),
  $puppet_provider        = params_lookup('puppet_provider'),
  $hiera_version          = params_lookup('hiera_version'),
  $hiera_package          = params_lookup('hiera_package'),
  $hiera_provider         = params_lookup('hiera_provider'),
  $hiera_backend_package  = params_lookup('hiera_backend_package'),
  $hiera_backend_version  = params_lookup('hiera_backend_version'),
  $hiera_backend_provider = params_lookup('hiera_backend_provider'),
) inherits puppet::params {

  if $puppet_version !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: puppet_version must be alphanumeric, got '${puppet_version}'")
  }

  if $puppet_package !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: puppet_package must be alphanumeric, got '${puppet_package}'")
  }

  if $hiera_version !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: hiera_version must be alphanumeric, got '${hiera_version}'")
  }

  if $hiera_package !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: hiera_package must be alphanumeric, got '${hiera_package}'")
  }

  package { 'puppet':
    ensure   => $puppet_version,
    name     => $puppet_package,
    provider => $puppet_provider,
  }

  package { 'hiera':
    ensure   => $hiera_version,
    name     => $hiera_package,
    provider => $hiera_provider,
  }

  if $hiera_backend_package != undef {
    package { $hiera_backend_package:
      ensure   => $hiera_backend_version,
      provider => $hiera_backend_provider,
    }
  }
}
