#puppet

##Overview

Manage the Puppet package state and run Puppet in masterless mode on a regular basis. When changes are applied, a list
of users can be notified.

##Usage

Install puppet and hiera:

```
class { 'puppet': }
```

Install a specific version of puppet and hiera:

```
class { 'puppet':
  puppet_ensure => '3.7.3-1puppetlabs1',
  hiera_ensure  => '1.3.3-1puppetlabs1',
}
```

Install puppet, hiera and the hiera backend `hiera-eyaml`:

```
class { 'puppet':
  hiera_backend_package => 'hiera-eyaml',
  hiera_backend_ensure  => '2.0.0',
}
```

Run puppet every thirty minutes and notify `root@example.com` in case changes have been made:

```
class { 'puppet::masterless':
  mail_to => 'root@example.com',
}
```

Run puppet every six hours:

```
class { 'puppet::masterless':
  cron_hour   => '*/6',
  cron_minute => fqdn_rand(60),
}
```

See [the cron type reference](https://docs.puppetlabs.com/references/stable/type.html#cron) for more information about
the available cron options.

##Limitations

The module has been tested on the following operating systems. Testing and patches for other platforms are welcome.

* Debian 6.0 (Squeeze)
* Debian 7.0 (Wheezy)
* Ubuntu 12.04 (Precise Pangolin)
* Ubuntu 14.04 (Trusty Tahr)

[![Build Status](https://travis-ci.org/tohuwabohu/puppet-roundcube.png?branch=master)](https://travis-ci.org/tohuwabohu/puppet-roundcube)

##Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

###Development

This project uses rspec-puppet and beaker to ensure the module works as expected and to prevent regressions.

```
gem install bundler
bundle install --path vendor

bundle exec rake spec
bundle exec rake beaker
```
(note: see [Beaker - Supported ENV variables](https://github.com/puppetlabs/beaker/wiki/How-to-Write-a-Beaker-Test-for-a-Module#beaker-rspec-details)
for a list of environment variables to control the default behaviour of Beaker)
