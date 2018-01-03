# == Class otrs::webserver
#
# This class is called from otrs for managing the webserver.
#
class otrs::webserver {

  # Deploy Apache running as the OTRS user
  class { '::apache':
    user          => $::otrs::params::user,
    manage_user   => false,
    default_vhost => false,
    mpm_module    => 'prefork', # Use the recommended multi-processing module in Apache
  }

  # Load the Apache Perl module
  include ::apache::mod::perl
  # Load the Apache headers module to improve UI speed
  include ::apache::mod::headers

  ::apache::vhost { 'otrs':
    port          => '80',
    docroot       => "${::otrs::params::base_dir}/var/httpd/htdocs/",
    docroot_owner => $::otrs::params::user,
    docroot_group => $::otrs::params::web_group,
  }

}
