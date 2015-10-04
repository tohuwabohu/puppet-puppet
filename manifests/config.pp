# == Class: puppet_masterless::config
#
# Set up everything required to run Puppet on a regular basis.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class puppet_masterless::config inherits puppet_masterless {
  $cron_ensure = $puppet_masterless::cron_enable ? {
    false   => absent,
    default => present,
  }

  file { $puppet_masterless::cron_file:
    ensure  => file,
    content => template('puppet_masterless/puppet-apply.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  cron { 'puppet':
    ensure      => $cron_ensure,
    command     => $puppet_masterless::cron_file,
    environment => "PATH=${puppet_masterless::exec_path}",
    user        => 'root',
    hour        => $puppet_masterless::cron_hour,
    minute      => $puppet_masterless::cron_minute,
    require     => File[$puppet_masterless::cron_file],
  }

  # TODO: remove me in the future
  file { ['/etc/logrotate.d/puppet', '/etc/cron.daily/puppet-apply']:
    ensure => absent,
    backup => false,
  }
}
