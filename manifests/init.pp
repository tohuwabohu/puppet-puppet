# == Class: masterless
#
# Install and manage Puppet.
#
# === Parameters
#
# [*ensure*]
#   Set the state the masterless mode should be in: either present or absent.
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
# [*puppet_conf_dir*]
#   Set the main configuration directory (e.g. /etc/puppet).
#
# [*puppet_manifest_file*]
#   Set the manifest file to be executed.
#
# [*puppet_log_dir*]
#   Set the directory where to write the log file.
#
# [*hiera_ensure*]
#   Set state the package should be in.
#
# [*hiera_provider*]
#   Set the provider used to install hiera.
#
# [*hiera_backend_ensure*]
#   Set the state the hiera backend should be in.
#
# [*hiera_backend_package*]
#   Set the name of the hiera backend to be installed.
#
# [*hiera_backend_provider*]
#   Set the provider used to install the hiera backend package.
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
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class masterless (
  $ensure                 = $masterless::params::ensure,
  $puppet_ensure          = $masterless::params::puppet_ensure,
  $puppet_package         = $masterless::params::puppet_package,
  $puppet_provider        = $masterless::params::puppet_provider,
  $puppet_conf_dir        = $masterless::params::puppet_conf_dir,
  $puppet_manifest_file   = $masterless::params::puppet_manifest_file,
  $puppet_log_dir         = $masterless::params::puppet_log_dir,
  $hiera_ensure           = $masterless::params::hiera_ensure,
  $hiera_package          = $masterless::params::hiera_package,
  $hiera_provider         = $masterless::params::hiera_provider,
  $hiera_backend_ensure   = $masterless::params::hiera_backend_ensure,
  $hiera_backend_package  = $masterless::params::hiera_backend_package,
  $hiera_backend_provider = $masterless::params::hiera_backend_provider,
  $rotate                 = $masterless::params::puppet_rotate,
  $rotate_every           = $masterless::params::puppet_rotate_every,
  $rotate_size            = $masterless::params::puppet_rotate_size,
  $mail_to                = undef,
  $mail_subject           = $masterless::params::puppet_mail_subject,

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

  validate_absolute_path($puppet_conf_dir)
  validate_absolute_path($puppet_manifest_file)
  validate_absolute_path($puppet_log_dir)

  if $ensure !~ /^present$|^absent$/ {
    fail("Class[Masterless::Masterless]: ensure must be either 'present' or 'absent', got '${ensure}'")
  }
  if !is_integer($rotate) {
    fail("Class[Masterless::Masterless]: rotate must be an integer, got '${rotate}'")
  }
  if !empty($mail_to) and empty($mail_subject) {
    fail('Class[Masterless::Masterless]: mail_subject cannot be empty')
  }

  $log_file_ensure = $ensure ? {
    absent  => absent,
    default => file,
  }
  $log_file = "${puppet_log_dir}/puppet.log"

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
      ensure   => $hiera_backend_ensure,
      provider => $hiera_backend_provider,
    }
  }

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
    path          => "${puppet_log_dir}/*.log",
    rotate        => $rotate,
    rotate_every  => $rotate_every,
    size          => $rotate_size,
    compress      => true,
    delaycompress => true,
    missingok     => true,
  }
}
