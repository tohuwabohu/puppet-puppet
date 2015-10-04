# == Class: puppet
#
# Install and manage Puppet.
#
# === Parameters
#
# [*puppet_ensure*]
#   Set state the Puppet packages should be in.
#
# [*puppet_packages*]
#   Set the list of Puppet packages to be installed.
#
# [*puppet_provider*]
#   Set the provider used to install the packages.
#
# [*puppet_conf_dir*]
#   Set the main configuration directory (e.g. `/etc/puppet`).
#
# [*puppet_manifest_file*]
#   Set the manifest file to be executed.
#
# [*hiera_ensure*]
#   Set state the package should be in.
#
# [*hiera_provider*]
#   Set the provider used to install hiera.
#
# [*hiera_backend_ensure*]
#   Set the version of the hiera backend.
#
# [*hiera_backend_package*]
#   Set the name of the hiera backend to be installed.
#
# [*hiera_backend_provider*]
#   Set the provider used to install the hiera backend package.
#
# [*cron_enable*]
#   Set to `true` to run Puppet on a regular basis; set to `false` to turn it off. Default is `true`.
#
# [*cron_file*]
#   The path to the script that is executed by cron. The script is managed by the class itself.
#
# [*cron_hour*]
#   The hour expression of the cron job.
#
# [*cron_minute*]
#   The minute expression of the cron job.
#
# [*mail_to*]
#   Set the email address where to send the puppet log in case the run changed something (or failed). (Optional)
#
# [*mail_subject*]
#   Set the subject of the email.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class puppet (
  $puppet_ensure          = $puppet::params::puppet_ensure,
  $puppet_packages        = $puppet::params::puppet_packages,
  $puppet_provider        = $puppet::params::puppet_provider,
  $puppet_conf_dir        = $puppet::params::puppet_conf_dir,
  $puppet_manifest_file   = $puppet::params::puppet_manifest_file,
  $hiera_ensure           = $puppet::params::hiera_ensure,
  $hiera_package          = $puppet::params::hiera_package,
  $hiera_provider         = $puppet::params::hiera_provider,
  $hiera_backend_ensure   = $puppet::params::hiera_backend_ensure,
  $hiera_backend_package  = $puppet::params::hiera_backend_package,
  $hiera_backend_provider = $puppet::params::hiera_backend_provider,
  $cron_enable            = $puppet::params::cron_enable,
  $cron_file              = $puppet::params::cron_file,
  $cron_hour              = $puppet::params::cron_hour,
  $cron_minute            = $puppet::params::cron_minute,
  $mail_to                = undef,
  $mail_subject           = $puppet::params::mail_subject,
  $exec_path              = $puppet::params::exec_path,
) inherits puppet::params {

  if $puppet_ensure !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: puppet_ensure must be alphanumeric, got '${puppet_ensure}'")
  }

  if empty($puppet_packages) {
    fail('Class[Puppet]: puppet_packages must not be empty')
  }

  validate_absolute_path($puppet_conf_dir)
  validate_absolute_path($puppet_manifest_file)

  if $hiera_ensure !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: hiera_ensure must be alphanumeric, got '${hiera_ensure}'")
  }

  if $hiera_package !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Puppet]: hiera_package must be alphanumeric, got '${hiera_package}'")
  }

  validate_bool($cron_enable)
  validate_absolute_path($cron_file)

  if !empty($mail_to) and empty($mail_subject) {
    fail('Class[Puppet]: mail_subject cannot be empty')
  }

  class { 'puppet::install': } ->
  class { 'puppet::config': }
}
