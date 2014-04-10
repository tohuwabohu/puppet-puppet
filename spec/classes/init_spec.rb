require 'spec_helper'

describe 'puppet' do
  let(:title) { 'puppet' }

  describe 'by default' do
    let(:params) { {} }

    it { should contain_package('puppet').with_ensure('latest') }
    it { should contain_package('hiera').with_ensure('latest') }
  end

  describe 'installs specified hiera backend' do
    let(:params) { {:hiera_backend_package => 'hiera-eyaml'} }

    it { should contain_package('hiera-eyaml').with_ensure('installed') }
    it { should contain_package('rubygems').with_ensure('latest') }
  end

  describe 'installs specified hiera backend with a certain version' do
    let(:params) { {:hiera_backend_package => 'hiera-eyaml', :hiera_backend_version => '1.0.0'} }

    it { should contain_package('hiera-eyaml').with_ensure('1.0.0') }
  end

  describe 'creates directory for archives cache' do
    let(:params) { {} }

    it { should contain_file('/var/cache/puppet/archives').with_ensure('directory') }
  end
end
