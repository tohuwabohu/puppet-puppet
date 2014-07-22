# == Class: puppet::masterless
#
# Run Puppet once a day in masterless mode.
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
# [*log_dir*]
#   Set the directory where to write the log file.
#
# [*rotate*]
#   Set the number of rotated log files to keep on disk.
#
# [*rotate_every*]
#   How often the log files should be rotated.
#   Valid values are 'hour', 'day', 'week', 'month' and 'year'.
#
# [*rotate_size*]
#   Set the size a log file has to reach before it will be rotated (optional).  The default units are bytes, append k,
#   M or G for kilobytes, megabytes or gigabytes respectively.
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
  $log_dir       = $puppet::params::puppet_log_dir,
  $rotate        = $puppet::params::puppet_rotate,
  $rotate_every  = $puppet::params::puppet_rotate_every,
  $rotate_size   = $puppet::params::puppet_rotate_size,
  $mail_to       = undef,
  $mail_subject  = $puppet::params::puppet_mail_subject,
) inherits puppet::params {

  validate_bool($enable)
  validate_absolute_path($conf_dir)
  validate_absolute_path($manifest_file)
  validate_absolute_path($log_dir)

  if $ensure !~ /^present$|^absent$/ {
    fail("Class[Puppet::Masterless]: ensure must be either 'present' or 'absent', got '${ensure}'")
  }
  if !is_integer($rotate) {
    fail("Class[Puppet::Masterless]: rotate must be an integer, got '${rotate}'")
  }
  if !empty($mail_to) and empty($mail_subject) {
    fail('Class[Puppet::Masterless]: mail_subject cannot be empty')
  }

  require puppet

  $log_file = "${log_dir}/puppet.log"
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
    require => Package['gawk'],
  }

  logrotate::rule { 'puppet':
    ensure        => $ensure,
    path          => "${log_dir}/*.log",
    rotate        => $rotate,
    rotate_every  => $rotate_every,
    size          => $rotate_size,
    compress      => true,
    delaycompress => true,
    missingok     => true,
  }
}
