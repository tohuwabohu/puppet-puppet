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
        'rotate'       => '7',
        'rotate_every' => 'day'
      )
    }
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

  describe 'with mail_to => foobar@example.com' do
    let(:params) { {:mail_to => 'foobar@example.com'} }

    it { should contain_file('/etc/cron.daily/puppet-apply').with_content(/mail/) }
    it { should contain_file('/etc/cron.daily/puppet-apply').with_content(/foobar@example.com/) }
  end

  describe 'with empty mail_to' do
    let(:params) { {:mail_to => ''} }

    it { should contain_file('/etc/cron.daily/puppet-apply').without_content(/mail/) }
  end
end