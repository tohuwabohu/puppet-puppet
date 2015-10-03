# == Class: puppet::masterless
#
# Run Puppet once a day in masterless mode. All logs are send to syslog.
#
# === Parameters
#
# [*ensure*]
#   Set the state the masterless mode should be in: either present or absent.
#
# [*enable*]
#   Set to `true` to enable the masterless mode once a day, to `false` to turn it off.
#
# [*conf_dir*]
#   Set the main configuration directory (e.g. /etc/puppet).
#
# [*manifest_file*]
#   Set the manifest file to be executed.
#
# [*mail_to*]
#   Set the email address where to send the puppet log in case the run changed something (or failed). (Optional)
#
# [*mail_subject*]
#   Set the subject of the email.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class puppet::masterless (
  $ensure        = $puppet::params::puppet_masterless_ensure,
  $enable        = $puppet::params::puppet_masterless_enable,
  $conf_dir      = $puppet::params::puppet_conf_dir,
  $manifest_file = $puppet::params::puppet_manifest_file,
  $mail_to       = undef,
  $mail_subject  = $puppet::params::puppet_mail_subject,
) inherits puppet::params {

  validate_bool($enable)
  validate_absolute_path($conf_dir)
  validate_absolute_path($manifest_file)

  if $ensure !~ /^present$|^absent$/ {
    fail("Class[Puppet::Masterless]: ensure must be either 'present' or 'absent', got '${ensure}'")
  }
  if !empty($mail_to) and empty($mail_subject) {
    fail('Class[Puppet::Masterless]: mail_subject cannot be empty')
  }

  require puppet

  $cron_file = $::osfamily ? {
    default => '/etc/cron.daily/puppet-apply',
  }
  $cron_file_enable = $enable ? {
    false   => absent,
    default => file,
  }
  $cron_file_ensure = $ensure ? {
    absent  => absent,
    default => $cron_file_enable,
  }

  file { $cron_file:
    ensure  => $cron_file_ensure,
    content => template('puppet/etc/cron.daily/puppet-apply.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  # TODO: remove me in the future
  file { '/etc/logrotate.d/puppet':
    ensure => absent,
    backup => false,
  }
}
