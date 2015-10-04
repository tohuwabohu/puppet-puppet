require 'spec_helper'

describe 'puppet' do
  let(:title) { 'puppet' }
  let(:cron_file) {'/usr/local/sbin/puppet-apply'}

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
    specify { should contain_file(cron_file).with(
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755'
      )
    }
    specify { should contain_file(cron_file).with_content(/"\/etc\/puppet"/) }
    specify { should contain_file(cron_file).with_content(/"\/etc\/puppet\/manifests\/site\.pp"/) }
    specify { should contain_file(cron_file).without_content(/mail/) }
    specify { should contain_cron('puppet').with_ensure('present') }
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
    let(:params) { {:puppet_packages => 'chef'} }

    it { should contain_package('chef') }
  end

  describe 'with empty puppet_package' do
    let(:params) { {:puppet_packages => ''} }

    it do
      expect { should contain_package('puppet') }.to raise_error(Puppet::Error, /puppet_package/)
    end
  end

  describe 'should not accept invalid puppet_conf_dir' do
    let(:params) { {:puppet_conf_dir => 'invalid conf_dir'} }

    it do
      expect { should contain_package('puppet') }.to raise_error(Puppet::Error, /invalid conf_dir/)
    end
  end

  describe 'should not accept invalid puppet_manifest_file' do
    let(:params) { {:puppet_manifest_file => 'foo bar'} }

    it do
      expect { should contain_package('puppet') }.to raise_error(Puppet::Error, /foo bar/)
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
    let(:params) { {:hiera_backend_package => 'hiera-eyaml', :hiera_backend_ensure => '1.0.0'} }

    it { should contain_package('hiera-eyaml').with_ensure('1.0.0') }
  end


  describe 'with cron_enable => false' do
    let(:params) { {:cron_enable => false} }

    specify { should contain_cron('puppet').with_ensure('absent') }
  end

  describe 'should not accept invalid cron_file' do
    let(:params) { {:cron_file => 'foo bar'} }

    it do
      expect { should contain_file(cron_file) }.to raise_error(Puppet::Error, /foo bar/)
    end
  end

  describe 'with cron_file => /some/path' do
    let(:params) { {:cron_file => '/some/path'} }

    specify { should contain_file('/some/path').with_ensure('file') }
    specify { should contain_cron('puppet').with_command('/some/path') }
  end

  describe 'with mail_to => foobar@example.com' do
    let(:params) { {:mail_to => 'foobar@example.com'} }

    specify { should contain_file(cron_file).with_content(/mail/) }
    specify { should contain_file(cron_file).with_content(/foobar@example.com/) }
  end

  describe 'with empty mail_to' do
    let(:params) { {:mail_to => ''} }

    specify { should contain_file(cron_file).without_content(/mail/) }
  end

  describe 'with subject => puppet changed something' do
    let(:params) { {:mail_to => 'root@example.com', :mail_subject => 'puppet changed something'} }

    specify { should contain_file(cron_file).with_content(/mail -s "puppet changed something"/) }
  end

  describe 'with empty mail_subject' do
    let(:params) { {:mail_to => 'root@example.com', :mail_subject => ''} }

    it do
      expect { should contain_file(cron_file) }.to raise_error(Puppet::Error, /mail_subject/)
    end
  end
end
