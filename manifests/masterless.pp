# == Class: puppet::masterless
#
# Run Puppet every 30 minutes in masterless mode. All logs are send to syslog.
#
# === Parameters
#
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class puppet::masterless inherits puppet {
  $cron_ensure = $puppet::cron_enable ? {
    false   => absent,
    default => present,
  }

  file { $puppet::cron_file:
    ensure  => file,
    content => template('puppet/puppet-apply.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  cron { 'puppet':
    ensure      => $cron_ensure,
    command     => $puppet::cron_file,
    environment => "PATH=${puppet::exec_path}",
    user        => 'root',
    hour        => $puppet::cron_hour,
    minute      => $puppet::cron_minute,
  }

  # TODO: remove me in the future
  file { ['/etc/logrotate.d/puppet', '/etc/cron.daily/puppet-apply']:
    ensure => absent,
    backup => false,
  }
}
