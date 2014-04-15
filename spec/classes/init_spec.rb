require 'spec_helper'

describe 'puppet' do
  let(:title) { 'puppet' }

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
  end

  describe 'with puppet_version => 1.2.3' do
    let(:params) { {:puppet_version => '1.2.3'} }

    it { should contain_package('puppet').with_ensure('1.2.3') }
  end

  describe 'with empty puppet_version' do
    let(:params) { {:puppet_version => ''} }

    it do
      expect { should contain_package('puppet') }.to raise_error(Puppet::Error, /puppet_version/)
    end
  end

  describe 'with puppet_package => chef' do
    let(:params) { {:puppet_package => 'chef'} }

    it { should contain_package('puppet').with_name('chef') }
  end

  describe 'with empty puppet_package' do
    let(:params) { {:puppet_package => ''} }

    it do
      expect { should contain_package('puppet') }.to raise_error(Puppet::Error, /puppet_package/)
    end
  end

  describe 'with hiera_version => 1.2.3' do
    let(:params) { {:hiera_version => '1.2.3'} }

    it { should contain_package('hiera').with_ensure('1.2.3') }
  end

  describe 'with empty hiera_version' do
    let(:params) { {:hiera_version => ''} }

    it do
      expect { should contain_package('hiera') }.to raise_error(Puppet::Error, /hiera_version/)
    end
  end

  describe 'with hiera_package => line' do
    let(:params) { {:hiera_package => 'line'} }

    it { should contain_package('hiera').with_name('line') }
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
end
