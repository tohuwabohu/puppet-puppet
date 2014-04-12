# == Class: puppet::hiera
#
# Manage hiera.
#
# === Parameters
#
# [*ensure*]
#   Set the version of hiera to be installed.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class puppet::hiera (
  $ensure = installed,
) {
  package { 'hiera': ensure => $ensure }
}
