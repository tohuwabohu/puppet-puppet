require 'spec_helper'

describe 'puppet::masterless' do
  let(:title) {'puppet::masterless'}

  describe 'by default' do
    let(:facts) { {} }

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

  describe 'should not accept invalid conf_dir' do
    let(:params) { {:conf_dir => 'invalid conf_dir'} }

    it do
      expect { should contain_file('/etc/cron.daily/puppet-apply') }.to raise_error(Puppet::Error, /invalid conf_dir/)
    end
  end

  describe 'with invalid manifest_file' do
    let(:params) { {:manifest_file => 'foo bar'} }

    it do
      expect { should contain_file('/etc/cron.daily/puppet-apply') }.to raise_error(Puppet::Error, /foo bar/)
    end
  end

  describe 'with invalid log_dir' do
    let(:params) { {:log_dir => 'foo bar'} }

    it do
      expect { should contain_file('/etc/cron.daily/puppet-apply') }.to raise_error(Puppet::Error, /foo bar/)
    end
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
