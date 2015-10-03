# == Class: puppet::masterless
#
# Run Puppet every 30 minutes in masterless mode. All logs are send to syslog.
#
# === Parameters
#
# [*ensure*]
#   Set the state the masterless mode should be in: either present or absent.
#
# [*enable*]
#   Set to `true` to run Puppet on a regular basis; set to `false` to turn it off.
#
# [*conf_dir*]
#   Set the main configuration directory (e.g. `/etc/puppet`).
#
# [*manifest_file*]
#   Set the manifest file to be executed.
#
# [*cron_file*]
#   The path to the script that is executed by cron. The script is managed by the class itself.
#
# [*cron_hour*]
#   The hour expression of the cron job.
#
# [*cron_minute*]
#   The minute expression of the cron job.
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
  $cron_file     = $puppet::params::puppet_cron_file,
  $cron_hour     = $puppet::params::puppet_cron_hour,
  $cron_minute   = $puppet::params::puppet_cron_minute,
  $mail_to       = undef,
  $mail_subject  = $puppet::params::puppet_mail_subject,
) inherits puppet::params {

  validate_bool($enable)
  validate_absolute_path($conf_dir)
  validate_absolute_path($manifest_file)
  validate_absolute_path($cron_file)

  if $ensure !~ /^present$|^absent$/ {
    fail("Class[Puppet::Masterless]: ensure must be either 'present' or 'absent', got '${ensure}'")
  }
  if !empty($mail_to) and empty($mail_subject) {
    fail('Class[Puppet::Masterless]: mail_subject cannot be empty')
  }

  require puppet

  $cron_ensure = $enable ? {
    false   => absent,
    default => $ensure,
  }

  file { $cron_file:
    ensure  => $ensure,
    content => template('puppet/puppet-apply.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  cron { 'puppet':
    ensure      => $cron_ensure,
    command     => $cron_file,
    environment => "PATH=${puppet::exec_path}",
    user        => 'root',
    hour        => $cron_hour,
    minute      => $cron_minute,
  }

  # TODO: remove me in the future
  file { ['/etc/logrotate.d/puppet', '/etc/cron.daily/puppet-apply']:
    ensure => absent,
    backup => false,
  }
}
