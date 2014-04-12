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

  describe 'with mail_to' do
    let(:params) { {:mail_to => 'foobar@example.com'} }

    it { should contain_file('/etc/cron.daily/puppet-apply').with_content(/mail/) }
    it { should contain_file('/etc/cron.daily/puppet-apply').with_content(/foobar@example.com/) }
  end
end