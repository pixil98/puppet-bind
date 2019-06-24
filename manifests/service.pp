# == Class: bind
#
#   This class ccontrols the ISC Bind service. This is a private class.
#
class bind::service {
  service { $bind::service_name:
    ensure     => running,
    name       => $bind::service_name,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
