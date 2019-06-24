# == Class: bind
#
#   This class controls the acls configuration. This is a private class.
#
class bind::config::acls {
  concat { 'bind-named-conf-acls':
    ensure       => present,
    path         => "${bind::config_dir}/named.conf.acls",
    owner        => 'root',
    group        => $bind::bind_group,
    mode         => '0644',
    warn         => "// named.conf.acls: Managed by Puppet.\n",
    validate_cmd => $bind::config::validate_cmd,
  }
}
