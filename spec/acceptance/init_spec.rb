require 'spec_helper_acceptance'

describe 'puppet' do
  context 'by default' do
    let(:manifest) { "class { 'puppet': }" }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe package('puppet-common') do
      it { should be_installed }
    end

    describe package('puppet') do
      it { should be_installed }
    end

    describe package('hiera') do
      it { should be_installed }
    end

    describe file('/usr/local/sbin/puppet-apply') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 755 }
    end
  end

  context 'with custom versions' do
    let(:manifest) { <<-EOS
        class { 'puppet':
          puppet_ensure => '3.7.3-1puppetlabs1',
          hiera_ensure  => '1.3.3-1puppetlabs1',
        }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe package('puppet-common') do
      it { should be_installed.with_version('3.7.3-1puppetlabs1') }
    end

    describe package('puppet') do
      it { should be_installed.with_version('3.7.3-1puppetlabs1') }
    end

    describe package('hiera') do
      it { should be_installed.with_version('1.3.3-1puppetlabs1') }
    end
  end

  context 'with custom hiera_backend' do
    let(:manifest) { <<-EOS
        class { 'puppet':
          hiera_backend_package => 'hiera-eyaml',
          hiera_backend_ensure  => '2.0.0',
        }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe package('hiera-eyaml') do
      it { should be_installed.by('gem').with_version('2.0.0') }
    end
  end
end
