# == Class otrs::install
#
# This class is called from otrs for install.
#
class otrs::install {

  # Manage the webserver
  if $::otrs::manage_webserver {
    include ::otrs::webserver
  }

  # Manage the database
  if $::otrs::manage_database {
    include ::otrs::database
  }

  # Manage the base directory
  file { $::otrs::params::base_dir:
    ensure => directory,
    mode   => '0755',
    owner  => $::otrs::params::user,
    group  => $::otrs::params::web_group,
  }

  # Manage the user
  if $::otrs::manage_user {
    user { $::otrs::params::user:
      ensure  => present,
      comment => 'OTRS user',
      home    => $::otrs::params::base_dir,
      shell   => '/bin/true',
    }
  }

  # Install all required packages
  package { $::otrs::params::packages_required:
    ensure => installed,
  }

  # Install database connector packages
  case $::otrs::database_connector {
    'mysql': { $db_package = $::otrs::params::database_connector_mysql }
    'odbc':  { $db_package = $::otrs::params::database_connector_odbc  }
    'pg':    { $db_package = $::otrs::params::database_connector_pg    }
    default: { $db_package = $::otrs::params::database_connector_mysql }
  }
  package { $db_package:
    ensure => installed,
  }

  # Install extra optional packages
  package { $::otrs::extra_packages:
    ensure => installed,
  }

  # Interpret the version depending on installation type
  case ($::otrs::installation_type) {
    'package': {

      if empty($::otrs::version) {
        $package_state = 'present'
      } else {
        $package_state = $::otrs::version
      }

      package { $::otrs::package_name:
        ensure => present,
        notify => Exec['OTRS: SetPermissions'],
      }

    }
    default: {
      # Default to webinstallation
      if empty($::otrs::version) {
        $web_version = "latest-${::otrs::major_release}.0"
      } else {
        $web_version = $::otrs::version
      }

      # web installation
      archive { 'otrs':
        path            => "/tmp/otrs.tar.gz",
        source          => "http://ftp.otrs.org/pub/otrs/otrs-${web_version}.tar.gz",
        extract         => true,
        extract_path    => '/opt/',
        extract_command => "tar xfz %s --strip-components=1 -C ${::otrs::params::base_dir}",
        creates         => "${::otrs::params::base_dir}/bin",
        cleanup         => true,
        user            => $::otrs::params::user,
        group           => $::otrs::params::web_group,
        require         => File[$::otrs::params::base_dir],
        notify          => Exec['OTRS: SetPermissions'],
      }
    }
  }

  # Correct permissions on disk
  exec {'OTRS: SetPermissions':
    path        => "${::otrs::params::base_dir}/bin",
    refreshonly => true,
    cwd         => $::otrs::params::base_dir,
    command     => "otrs.SetPermissions.pl --otrs-user=${::otrs::params::user} --web-group=${::otrs::params::web_group}",
  }

  file { "${::otrs::params::base_dir}/var/cron/otrs_daemon":
    ensure => link,
    mode   => '0660',
    target => "${::otrs::params::base_dir}/var/cron/otrs_daemon.dist"
  }

  cron { 'otrs daemon':
    command => '$HOME/bin/otrs.Daemon.pl start >> /dev/null',
    user    => $::otrs::params::user,
    hour    => '*',
    minute  => '*/5',
  }

  # Link the OTRS Apache config
  file { "${::apache::params::confd_dir}/otrs.conf" :
    ensure => link,
    mode   => '0755',
    target => "${::otrs::params::base_dir}/scripts/apache2-httpd.include.conf",
    notify => Service[$::apache::params::service_name],
  }
}
