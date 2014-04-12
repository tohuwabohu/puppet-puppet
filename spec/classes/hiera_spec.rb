require 'spec_helper'

describe 'puppet::hiera' do
  let(:title) { 'hiera' }

  describe 'by default' do
    let(:params) { {} }

    it { should contain_package('hiera').with_ensure('installed') }
  end
end
