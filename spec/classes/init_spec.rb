require 'spec_helper'

describe 'masterless' do
  let(:title) { 'masterless' }

  describe 'by default' do
    let(:params) { {} }

    it { should contain_package('puppet').with(
        'ensure'   => 'installed',
        'name'     => 'puppet',
        'provider' => ''
      )
    }
    it { should contain_package('hiera').with(
        'ensure'   => 'installed',
        'name'     => 'hiera',
        'provider' => ''
      )
    }
    it { should contain_file('/etc/cron.daily/puppet-apply').with(
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755'
      )
    }
    it { should contain_file('/etc/cron.daily/puppet-apply').without_content(/mail/) }
    it { should contain_logrotate__rule('puppet').with(
        'ensure' => 'present',
        'rotate' => '5',
        'size'   => '100k'
      )
    }
  end

  describe 'with ensure => absent' do
    let(:params) { {:ensure => 'absent'} }

    it { should contain_file('/etc/cron.daily/puppet-apply').with_ensure('absent') }
    it { should contain_logrotate__rule('puppet').with_ensure('absent') }
  end

  describe 'with invalid ensure' do
    let(:params) { {:ensure => 'invalid'} }

    it do
      expect { should contain_file('/etc/cron.daily/puppet-apply') }.to raise_error(Puppet::Error, /invalid/)
    end
  end

  describe 'should not accept invalid puppet_conf_dir' do
    let(:params) { {:puppet_conf_dir => 'invalid conf_dir'} }

    it do
      expect { should contain_file('/etc/cron.daily/puppet-apply') }.to raise_error(Puppet::Error, /invalid conf_dir/)
    end
  end

  describe 'with invalid puppet_manifest_file' do
    let(:params) { {:puppet_manifest_file => 'foo bar'} }

    it do
      expect { should contain_file('/etc/cron.daily/puppet-apply') }.to raise_error(Puppet::Error, /foo bar/)
    end
  end

  describe 'with invalid puppet_log_dir' do
    let(:params) { {:puppet_log_dir => 'foo bar'} }

    it do
      expect { should contain_file('/etc/cron.daily/puppet-apply') }.to raise_error(Puppet::Error, /foo bar/)
    end
  end

  describe 'with puppet_ensure => 1.2.3' do
    let(:params) { {:puppet_ensure => '1.2.3'} }

    it { should contain_package('puppet').with_ensure('1.2.3') }
  end

  describe 'with empty puppet_ensure' do
    let(:params) { {:puppet_ensure => ''} }

    it do
      expect { should contain_package('puppet') }.to raise_error(Puppet::Error, /puppet_ensure/)
    end
  end

  describe 'with puppet_package => chef' do
    let(:params) { {:puppet_package => 'chef'} }

    it { should contain_package('chef') }
  end

  describe 'with empty puppet_package' do
    let(:params) { {:puppet_package => ''} }

    it do
      expect { should contain_package('puppet') }.to raise_error(Puppet::Error, /puppet_package/)
    end
  end

  describe 'with hiera_ensure => 1.2.3' do
    let(:params) { {:hiera_ensure => '1.2.3'} }

    it { should contain_package('hiera').with_ensure('1.2.3') }
  end

  describe 'with empty hiera_ensure' do
    let(:params) { {:hiera_ensure => ''} }

    it do
      expect { should contain_package('hiera') }.to raise_error(Puppet::Error, /hiera_ensure/)
    end
  end

  describe 'with hiera_package => line' do
    let(:params) { {:hiera_package => 'line'} }

    it { should contain_package('line') }
  end

  describe 'with empty hiera_package' do
    let(:params) { {:hiera_package => ''} }

    it do
      expect { should contain_package('hiera') }.to raise_error(Puppet::Error, /hiera_package/)
    end
  end

  describe 'with hiera_backend_package => hiera-eyaml' do
    let(:params) { {:hiera_backend_package => 'hiera-eyaml'} }

    it { should contain_package('hiera-eyaml').with_ensure('installed') }
  end

  describe 'with hiera_backend_package => hiera-eyaml and hiera_backend_version => 1.0.0' do
    let(:params) { {:hiera_backend_package => 'hiera-eyaml', :hiera_backend_version => '1.0.0'} }

    it { should contain_package('hiera-eyaml').with_ensure('1.0.0') }
  end

  describe 'with rotate => 10' do
    let(:params) { {:rotate => 10} }

    it { should contain_logrotate__rule('puppet').with_rotate(10) }
  end

  describe 'with invalid rotate' do
    let(:params) { {:rotate => 'invalid'} }

    it do
      expect { should contain_logrotate__rule('puppet') }.to raise_error(Puppet::Error, /rotate/)
    end
  end

  describe 'with rotate_every => week' do
    let(:params) { {:rotate_every => 'week'} }

    it { should contain_logrotate__rule('puppet').with_rotate_every('week') }
  end

  describe 'with invalid rotate_every' do
    let(:params) { {:rotate_every => 'Monday'} }

    it do
      expect { should contain_logrotate__rule('puppet') }.to raise_error(Puppet::Error, /rotate_every/)
    end
  end

  describe 'with rotate_size => 100k' do
    let(:params) { {:rotate_size => '100k'} }

    it { should contain_logrotate__rule('puppet').with_size('100k') }
  end

  describe 'with mail_to => foobar@example.com' do
    let(:params) { {:mail_to => 'foobar@example.com'} }

    it { should contain_file('/etc/cron.daily/puppet-apply').with_content(/mail/) }
    it { should contain_file('/etc/cron.daily/puppet-apply').with_content(/foobar@example.com/) }
  end

  describe 'with empty mail_to' do
    let(:params) { {:mail_to => ''} }

    it { should contain_file('/etc/cron.daily/puppet-apply').without_content(/mail/) }
  end

  describe 'with subject => puppet changed something' do
    let(:params) { {:mail_to => 'root@example.com', :mail_subject => 'puppet changed something'} }

    it { should contain_file('/etc/cron.daily/puppet-apply').with_content(/mail -s "puppet changed something"/) }
  end

  describe 'with empty mail_subject' do
    let(:params) { {:mail_to => 'root@example.com', :mail_subject => ''} }

    it do
      expect { should contain_file('/etc/cron.daily/puppet-apply') }.to raise_error(Puppet::Error, /mail_subject/)
    end
  end
end
