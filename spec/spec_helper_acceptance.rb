require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  ignore_list = %w(junit log spec tests vendor)

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      # Install module
      copy_module_to(host, :source => proj_root, :module_name => 'puppet', :ignore_list => ignore_list)

      # Install dependencies
      on host, puppet('module', 'install', 'rodjek-logrotate', '--version 1.1.1')
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version 4.9.0')
    end
  end
end
