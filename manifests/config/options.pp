# == Class: bind
#
#   This class controls the options configuration. This is a private class.
#
class bind::config::options {
  file { 'bind-named-conf-options':
    ensure       => file,
    path         => "${bind::config_dir}/named.conf.options",
    content      => epp('bind/named.conf.options'),
    owner        => 'root',
    group        => $bind::bind_group,
    mode         => '0644',
    validate_cmd => $bind::config::validate_cmd,
  }
}
