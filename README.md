#puppet

##Overview

Manage the Puppet installation.

##Usage

Install puppet and hiera:

```
class { 'puppet': }
```

Install a specific version of puppet and hiera:

```
class { 'puppet':
  puppet_version => '3.4.0',
  hiera_version  => '1.3.2',
}
```

Install puppet, hiera and the hiera backend `hiera-eyaml`:

```
class { 'puppet':
  hiera_backend_package => 'hiera-eyaml',
  hiera_backend_ensure  => '2.0.0',
}
```

Run puppet once a day and notify `root@example.com` in case changes have been made:

```
class { 'puppet::masterless':
  mail_to => 'root@example.com',
}
```

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
