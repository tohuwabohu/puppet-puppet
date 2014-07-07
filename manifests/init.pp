# == Class: masterless
#
# Install and manage Puppet.
#
# === Parameters
#
# [*puppet_ensure*]
#   Set state the package should be in.
#
# [*puppet_package*]
#   Set the name of the package to be installed.
#
# [*puppet_provider*]
#   Set the provider used to install the package.
#
# [*hiera_ensure*]
#   Set state the package should be in.
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
class masterless (
  $puppet_ensure          = $masterless::params::puppet_ensure,
  $puppet_package         = $masterless::params::puppet_package,
  $puppet_provider        = $masterless::params::puppet_provider,
  $hiera_ensure           = $masterless::params::hiera_ensure,
  $hiera_package          = $masterless::params::hiera_package,
  $hiera_provider         = $masterless::params::hiera_provider,
  $hiera_backend_package  = $masterless::params::hiera_backend_package,
  $hiera_backend_version  = $masterless::params::hiera_backend_version,
  $hiera_backend_provider = $masterless::params::hiera_backend_provider,
) inherits masterless::params {

  if $puppet_ensure !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Masterless]: puppet_ensure must be alphanumeric, got '${puppet_ensure}'")
  }

  if $puppet_package !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Masterless]: puppet_package must be alphanumeric, got '${puppet_package}'")
  }

  if $hiera_ensure !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Masterless]: hiera_ensure must be alphanumeric, got '${hiera_ensure}'")
  }

  if $hiera_package !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Masterless]: hiera_package must be alphanumeric, got '${hiera_package}'")
  }

  package { $puppet_package:
    ensure   => $puppet_ensure,
    provider => $puppet_provider,
  }

  package { $hiera_package:
    ensure   => $hiera_ensure,
    provider => $hiera_provider,
  }

  if $hiera_backend_package != undef {
    package { $hiera_backend_package:
      ensure   => $hiera_backend_version,
      provider => $hiera_backend_provider,
    }
  }
}
