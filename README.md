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
  puppet_versoin => '3.4.0',
  hiera_version  => '1.3.2',
}
```

Install puppet, hiera and the hiera backend `hiera-eyaml`:

```
class { 'puppet':
  hiera_backend_package => 'hiera-eyaml',
  hiera_backend_version => '2.0.0',
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

* Debian Linux 6.0 (Squeeze)

[![Build Status](https://travis-ci.org/tohuwabohu/tohuwabohu-puppet.png?branch=master)](https://travis-ci.org/tohuwabohu/tohuwabohu-puppet)

##Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

##Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You may also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
