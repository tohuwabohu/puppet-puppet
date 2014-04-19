# == Class: puppet::masterless
#
# Run Puppet once a day in masterless mode.
#
# === Parameters
#
# [*ensure*]
#   Set the state the masterless mode should be in: either present or absent.
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
  $manifest_file = $puppet::params::puppet_manifest_file,
  $log_dir       = $puppet::params::puppet_log_dir,
  $rotate        = $puppet::params::puppet_rotate,
  $rotate_every  = $puppet::params::puppet_rotate_every,
  $mail_to       = undef,
  $mail_subject  = $puppet::params::puppet_mail_subject,
) inherits puppet::params {

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

  $log_file_ensure = $ensure ? {
    absent  => absent,
    default => file,
  }
  $log_file = "${log_dir}/puppet.log"
  file { '/etc/cron.daily/puppet-apply':
    ensure  => $log_file_ensure,
    content => template('puppet/etc/cron.daily/puppet-apply.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['gawk'],
  }

  logrotate::rule { 'puppet':
    ensure        => $ensure,
    path          => $log_dir,
    rotate        => $rotate,
    rotate_every  => $rotate_every,
    compress      => true,
    delaycompress => true,
    missingok     => true,
  }
}
