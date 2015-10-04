# == Class: puppet_masterless::params
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
class puppet_masterless::params {
  $puppet_ensure = installed
  $puppet_packages = [ 'puppet-common', 'puppet' ]
  $puppet_provider = undef
  $puppet_conf_dir = '/etc/puppet'
  $puppet_manifest_file = '/etc/puppet/manifests/site.pp'

  $hiera_ensure = installed
  $hiera_package = 'hiera'
  $hiera_provider = undef

  $hiera_backend_ensure = installed
  $hiera_backend_package = undef
  $hiera_backend_provider = gem

  $cron_enable = true
  $cron_file = $::osfamily ? {
    default => '/usr/local/sbin/puppet-apply',
  }
  $cron_hour = '*'
  $cron_minute = fqdn_rand(30)

  $mail_subject = '[Puppet] Changes have been applied on $(hostname)'

  $exec_path = $::osfamily ? {
    default => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  }
}
