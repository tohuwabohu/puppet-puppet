require 'spec_helper_acceptance'

describe 'puppet::masterless' do
  let(:manifest) { <<-EOS
      package { 'gawk': ensure => installed }

      class { 'puppet::masterless': }
    EOS
  }

  specify 'should provision with no errors' do
    apply_manifest(manifest, :catch_failures => true)
  end

  specify 'should be idempotent' do
    apply_manifest(manifest, :catch_changes => true)
  end

  describe file('/etc/cron.daily/puppet-apply') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe command('/etc/cron.daily/puppet-apply') do
    its(:exit_status) { should eq 0 }
  end
end
