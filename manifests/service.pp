# == Class otrs::service
#
# This class is meant to be called from otrs.
# It ensure the service is running.
#
class otrs::service {

  service { $::otrs::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
