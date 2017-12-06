# == Class otrs::config
#
# This class is called from otrs for service config.
#
class otrs::config {

  # Manage the main configuration file
  file { "${::otrs::params::base_dir}/Kernel/Config.pm":
    ensure  => file,
    mode    => '0660',
    content => template('otrs/Config.pm.erb'),
    owner   => $::otrs::params::user,
    group   => $::otrs::params::web_group,
    notify  => Service[$::apache::params::service_name],
  }

}
