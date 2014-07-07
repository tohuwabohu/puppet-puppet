# == Class: masterless::masterless
#
# Run Puppet once a day in masterless mode.
#
# === Parameters
#
# [*ensure*]
#   Set the state the masterless mode should be in: either present or absent.
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
class masterless::masterless (
  $ensure        = $masterless::params::puppet_masterless_ensure,
  $conf_dir      = $masterless::params::puppet_conf_dir,
  $manifest_file = $masterless::params::puppet_manifest_file,
  $log_dir       = $masterless::params::puppet_log_dir,
  $rotate        = $masterless::params::puppet_rotate,
  $rotate_every  = $masterless::params::puppet_rotate_every,
  $rotate_size   = $masterless::params::puppet_rotate_size,
  $mail_to       = undef,
  $mail_subject  = $masterless::params::puppet_mail_subject,
) inherits masterless::params {

  validate_absolute_path($conf_dir)
  validate_absolute_path($manifest_file)
  validate_absolute_path($log_dir)

  if $ensure !~ /^present$|^absent$/ {
    fail("Class[Masterless::Masterless]: ensure must be either 'present' or 'absent', got '${ensure}'")
  }
  if !is_integer($rotate) {
    fail("Class[Masterless::Masterless]: rotate must be an integer, got '${rotate}'")
  }
  if !empty($mail_to) and empty($mail_subject) {
    fail('Class[Masterless::Masterless]: mail_subject cannot be empty')
  }

  require masterless

  $log_file_ensure = $ensure ? {
    absent  => absent,
    default => file,
  }
  $log_file = "${log_dir}/puppet.log"
  file { '/etc/cron.daily/puppet-apply':
    ensure  => $log_file_ensure,
    content => template('masterless/etc/cron.daily/puppet-apply.erb'),
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
