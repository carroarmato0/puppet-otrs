# Class: otrs
# ===========================
#
# Full description of class otrs here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class otrs (
  $package_name = $::otrs::params::package_name,
  $service_name = $::otrs::params::service_name,
) inherits ::otrs::params {

  # validate parameters here

  class { '::otrs::install': } ->
  class { '::otrs::config': } ~>
  class { '::otrs::service': } ->
  Class['::otrs']
}
