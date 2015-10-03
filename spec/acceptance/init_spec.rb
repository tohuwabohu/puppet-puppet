require 'spec_helper_acceptance'

describe 'by default' do
  context 'by default' do
    let(:manifest) { "class { 'puppet': }" }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe package('puppet') do
      it { should be_installed }
    end

    describe package('hiera') do
      it { should be_installed }
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
