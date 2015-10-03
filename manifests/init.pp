# == Class: puppet
#
# Install and manage Puppet.
#
# === Parameters
#
# [*puppet_ensure*]
#   Set state the Puppet packages should be in.
#
# [*puppet_packages*]
#   Set the list of Puppet packages to be installed.
#
# [*puppet_provider*]
#   Set the provider used to install the packages.
#
# [*hiera_ensure*]
#   Set state the package should be in.
#
# [*hiera_provider*]
#   Set the provider used to install hiera.
#
# [*hiera_backend_ensure*]
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
  $puppet_ensure          = $puppet::params::puppet_ensure,
  $puppet_packages        = $puppet::params::puppet_packages,
  $puppet_provider        = $puppet::params::puppet_provider,
  $hiera_ensure           = $puppet::params::hiera_ensure,
  $hiera_package          = $puppet::params::hiera_package,
  $hiera_provider         = $puppet::params::hiera_provider,
  $hiera_backend_ensure   = $puppet::params::hiera_backend_ensure,
  $hiera_backend_package  = $puppet::params::hiera_backend_package,
  $hiera_backend_provider = $puppet::params::hiera_backend_provider,
) inherits puppet::params {

  if $puppet_ensure !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: puppet_ensure must be alphanumeric, got '${puppet_ensure}'")
  }

  if $hiera_ensure !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: hiera_ensure must be alphanumeric, got '${hiera_ensure}'")
  }

  if $hiera_package !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: hiera_package must be alphanumeric, got '${hiera_package}'")
  }

  $real_puppet_packages = any2array($puppet_packages)

  package { $real_puppet_packages:
    ensure   => $puppet_ensure,
    provider => $puppet_provider,
  }

  package { $hiera_package:
    ensure   => $hiera_ensure,
    provider => $hiera_provider,
  }

  if $hiera_backend_package != undef {
    package { $hiera_backend_package:
      ensure   => $hiera_backend_ensure,
      provider => $hiera_backend_provider,
    }
  }
}
