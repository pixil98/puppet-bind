# == Class: bind
#
#   This class instals the ISC Bind package
#
class bind::install {
  if $bind::package_manage {
    package { $bind::package_name:
      ensure => $bind::package_ensure,
    }
  }
}
