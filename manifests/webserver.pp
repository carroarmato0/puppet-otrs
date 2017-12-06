# == Class otrs::webserver
#
# This class is called from otrs for managing the webserver.
#
class otrs::webserver {

  class { '::apache':
    user          => $::otrs::params::user,
    manage_user   => false,
    default_vhost => false,
  }

  include ::apache::mod::perl

  ::apache::vhost { 'otrs':
    port          => '80',
    docroot       => "${::otrs::params::base_dir}/var/httpd/htdocs/",
    docroot_owner => $::otrs::params::user,
    docroot_group => $::otrs::params::web_group,
  }

}
