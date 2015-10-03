require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  ignore_list = %w(junit log spec tests vendor)

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      if fact('operatingsystem') == 'Ubuntu'
        on host, 'apt-get install -y exim4-daemon-light'
      end
      if fact('operatingsystem') == 'Ubuntu' and fact('operatingsystemmajrelease') == '12.04'
        on host, 'apt-get install -y rubygems'

        # Pin version of highline to a Ruby 1.8.7 compatible
        on host, 'gem install highline --version 1.6.21'
      end
      if fact('operatingsystem') == 'Ubuntu' and fact('operatingsystemmajrelease') == '14.04'
        on host, 'apt-get install -y ruby'
      end

      # Install module
      copy_module_to(host, :source => proj_root, :module_name => 'puppet', :ignore_list => ignore_list)

      # Install dependencies
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version 4.9.0')
    end
  end
end
