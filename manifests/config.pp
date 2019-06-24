# == Class: bind
#
#   This class configures ISC Bind. This is a private class.
#
class bind::config {

  # Config file validation
  case $bind::validate_config {
    true: {
      $validate_cmd = "${lookup(bind::config::validate_cmd)} %"
    }
    default: {
      $validate_cmd = undef
    }
  }

  $named_conf_file = "${bind::config_dir}/named.conf"
  file { $named_conf_file:
    ensure       => file,
    content      => epp('bind/named.conf'),
    owner        => 'root',
    group        => $bind::bind_group,
    mode         => '0644',
    validate_cmd => $bind::config::validate_cmd,
  }

  contain bind::config::acls
  contain bind::config::keys
  contain bind::config::options
  contain bind::config::zones

  Class['bind::config::acls']
  -> Class['bind::config::keys']
  -> Class['bind::config::options']
  -> Class['bind::config::zones']
  -> File[$named_conf_file]
}
