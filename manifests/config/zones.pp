# == Class: bind
#
#   This class controls the zones configuration. This is a private class.
#
class bind::config::zones {
  concat { 'bind-named-conf-zones':
    ensure       => present,
    path         => "${bind::config_dir}/named.conf.zones",
    owner        => 'root',
    group        => $bind::bind_group,
    mode         => '0644',
    warn         => "// named.conf.zones: Managed by Puppet.\n",
    validate_cmd => $bind::config::validate_cmd,
  }

  if $bind::manage_zones {
    $purge = true
  }

  file { "${bind::config_dir}/hosted-domains/":
    ensure  => directory,
    owner   => $bind::bind_user,
    group   => $bind::bind_group,
    mode    => '0644',
    purge   => $purge,
    recurse => $purge,
  }
}
