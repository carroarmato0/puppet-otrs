# == Class otrs::install
#
# This class is called from otrs for install.
#
class otrs::install {

  package { $::otrs::package_name:
    ensure => present,
  }
}
