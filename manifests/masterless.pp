# == Class: puppet::masterless
#
# Run Puppet once a day in masterless mode.
#
# === Parameters
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
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class puppet::masterless (
  $manifest_file = $puppet::params::puppet_manifest_file,
  $log_dir       = $puppet::params::puppet_log_dir,
  $rotate        = $puppet::params::puppet_rotate,
  $rotate_every  = $puppet::params::puppet_rotate_every,
  $mail_to       = undef,
) inherits puppet::params {

  require puppet

  $log_file = "${log_dir}/puppet.log"
  file { '/etc/cron.daily/puppet-apply':
    ensure  => file,
    content => template('puppet/etc/cron.daily/puppet-apply.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['gawk'],
  }

  logrotate::rule { 'puppet':
    path          => $log_dir,
    rotate        => $rotate,
    rotate_every  => $rotate_every,
    compress      => true,
    delaycompress => true,
    missingok     => true,
  }
}
