# Class: otrs
# ===========================
#
# This module allows you to install and manage an OTRS installation
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class otrs (
  Optional[String]          $package_name       = $::otrs::params::package_name,
  Optional[String]          $version            = $::otrs::params::version,
  Integer                   $major_release      = $::otrs::params::major_release,
  Enum['package','web']     $installation_type  = $::otrs::params::installation_type,
  Boolean                   $manage_user        = $::otrs::params::manage_user,
  Optional[Array[String]]   $extra_packages     = $::otrs::params::extra_packages,
  Boolean                   $manage_webserver   = $::otrs::params::manage_webserver,
  Enum['mysql','odbc','pg'] $database_connector = $::otrs::params::database_connector,
  String                    $db_host            = $::otrs::params::db_host,
  String                    $db_name            = $::otrs::params::db_name,
  String                    $db_password        = $::otrs::params::db_password,
  Boolean                   $manage_database    = $::otrs::params::manage_database,
  Hash[String,String]       $config_hash        = {},
  String                    $config_block       = '',
) inherits ::otrs::params {

  class { '::otrs::install': } ->
  class { '::otrs::config': } ~>
  Class['::otrs']
}
