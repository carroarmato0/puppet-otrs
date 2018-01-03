# == Class otrs::params
#
# This class is meant to be called from otrs.
# It sets variables according to platform.
#
class otrs::params {

  $package_name       = 'otrs'
  $major_release      = 5
  $installation_type  = 'package'
  $base_dir           = '/opt/otrs'
  $manage_user        = true
  $version            = undef

  $user               = 'otrs'
  $extra_packages     = []
  $manage_webserver   = true

  $manage_database    = true
  $database_connector = 'mysql'
  $db_host            = '127.0.0.1'
  $db_user            = 'otrs'
  $db_name            = 'otrs'
  $db_password        = 'otrs'

  # OS defaults
  case $::osfamily {
    'Debian': {
      $web_group = 'www-data'

      $packages_required = [
        'libarchive-zip-perl',
        'libdbi-perl',
        'libnet-dns-perl',
        'libtemplate-perl',
        'libyaml-libyaml-perl',
        'libnet-ldap-perl',
        'libjson-xs-perl',
        'libxml-libxslt-perl',
        'libmail-imapclient-perl',
        'libencode-hanextra-perl',
        'libtext-csv-xs-perl',
      ]

      $database_connector_mysql = [
        'libdbd-mysql-perl',
      ]
      $database_connector_odbc = [
        'libdbd-odbc-perl',
      ]
      $database_connector_pg = [
        'libdbd-pg-perl',
      ]
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }


}
