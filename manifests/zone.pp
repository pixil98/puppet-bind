define bind::zone (
  Bind::Zone::Type                        $type,
  Stdlib::Fqdn                            $domain = $title,
  Bind::Zone::Class                       $class = 'IN',
  Boolean                                 $validate = lookup('bind::zone::validate'),
  Optional[Stdlib::Filesource]            $source = undef,
  Optional[Bind::Zone::Ttl]               $ttl = undef,
  # Zone options
  Optional[Array[Bind::Address_match]]    $allow_transfer = undef,
  Optional[Array[Bind::Address_match]]    $also_notify = undef,
  Optional[Array[String]]                 $masters = undef,
  Optional[Enum['yes', 'no', 'explicit']] $ns_notify = undef,
  Optional[Array[String]]                 $update_policy = undef,
) {

  # == Validate params ==
  if (($source !~ Undef) and !member(['master', 'hint'], $type)) {
    fail("source may only be provided for bind::zone resources with type 'master', or 'hint'")
  }
  if (($allow_transfer !~ Undef) and !member(['master', 'slave', 'mirror'], $type)) {
    fail("allow_transfer may only be provided for bind::zone resources with type 'master', 'slave', or 'mirror'")
  }
  if (!($also_notify =~ Undef) and !member(['master', 'slave'], $type)) {
    fail("also_notify may only be provided for bind::zone resources with type 'master' or 'slave'")
  }
  if (!($masters =~ Undef) and !member(['slave', 'stub'], $type)) {
    fail("masters may only be provided for bind::zone resources with type 'slave' or 'stub'")
  }
  if !($ns_notify =~ Undef) {
    if !member(['master', 'slave'], $type) {
      fail("ns_notify may only be provided for bind::zone resources with type 'master' or 'slave'")
    }
    if ($ns_notify == 'explicit') and ($also_notify =~ Undef) {
      fail("ns_notify is set to 'explicit' but also_notify isn't defined")
    }
  }
  if (!($update_policy =~ Undef) and ($type != 'master')) {
    fail("update_policy may only be provided for bind::zone resources with type 'master'")
  }


  if $type == 'master' {
    $zone_file = "${lookup(bind::config_dir)}/hosted-domains/db.${domain}"
  } elsif $type == 'slave' {
    $zone_file = "/var/lib/bind/db.${domain}"
  } else {
    $zone_file = undef
  }

  #
  # == Zone declaration ==
  $zone_template_params = {
    domain         => $domain,
    zone_type      => $type,
    zone_class     => $class,
    allow_transfer => $allow_transfer,
    also_notify    => $also_notify,
    file           => $zone_file,
    journal        => "${lookup(bind::var_dir)}/db.${domain}.jnl",
    masters        => $masters,
    notify         => $notify,
    update_policy  => $update_policy,
  }

  concat::fragment { "bind-zone-config-${domain}":
    order   => '10',
    target  => 'bind-named-conf-zones',
    content => epp('bind/zone.epp', $zone_template_params),
  }

  #
  # == Zone file ==
  if $type == 'master' {
    # Zone file validation
    $bind_group = lookup(bind::bind_group)
    case $validate {
      true: {
        $validate_cmd = "${lookup(bind::zone::validate_cmd)} ${domain} %"
      }
      default: {
        $validate_cmd = undef
      }
    }

    # If a source was passed in, use it. Otherwise setup a concat target
    if $source !~ Undef {
      file { $zone_file:
        source       => $source,
        owner        => 'root',
        group        => $bind_group,
        mode         => '0644',
        validate_cmd => $validate_cmd,
      }
    } else {
      concat { "bind-zone-${domain}":
        ensure       => present,
        path         => $zone_file,
        owner        => 'root',
        group        => $bind_group,
        mode         => '0644',
        warn         => "; ${zone_file}: Managed by Puppet.\n",
        validate_cmd => $validate_cmd,
      }
      concat::fragment { "bind-zone-${domain}-origin":
        order   => '1',
        target  => "bind-zone-${domain}",
        content => "\$ORIGIN ${domain}\n",
      }
      concat::fragment { "bind-zone-${domain}-ttl":
        order   => '2',
        target  => "bind-zone-${domain}",
        content => "\$TTL ${ttl}\n",
      }
    }
  }
}
