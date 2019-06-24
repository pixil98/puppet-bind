# == Class: bind
#
#   This class controls the keys configuration. This is a private class.
#
class bind::config::keys {
  concat { 'bind-named-conf-keys':
    ensure       => present,
    path         => "${bind::config_dir}/named.conf.keys",
    owner        => 'root',
    group        => $bind::bind_group,
    mode         => '0644',
    warn         => "// named.conf.keys: Managed by Puppet.\n",
    validate_cmd => $bind::config::validate_cmd,
  }
}
