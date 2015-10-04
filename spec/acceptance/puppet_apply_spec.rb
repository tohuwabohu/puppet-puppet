require 'spec_helper_acceptance'

describe 'puppet-apply' do
  before :all do
    create_remote_file(default, '/etc/puppet/manifests/site.pp', "
      node default {
        file { '/tmp/a-resource':
          ensure => present
        }
      }
    ")
  end

  context 'by default' do
    before :all do
      # Simulate a change
      on default, 'rm -f /tmp/a-resource'
    end

    let(:manifest) { "class {'puppet': }" }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    describe command('puppet-apply') do
      its(:exit_status) { should eq 0 }
    end

    describe file('/tmp/a-resource') do
      it { should be_file }
    end
  end

  context 'with email address' do
    before :all do
      on default, 'rm -f /var/spool/mail/mail'

      # Simulate a change
      on default, 'rm -f /tmp/a-resource'
    end

    let(:manifest) { <<-EOS
        class { 'puppet':
          mail_to => 'root',
        }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe command('puppet-apply') do
      its(:exit_status) { should eq 0 }
    end

    # Root should have a message
    describe file('/var/spool/mail/mail') do
      let(:pre_command) { 'sleep 1' }  # email is asynchronous
      it { should be_file }
      it { should contain('Changes have been applied') }
    end
  end
end
