define bind::record::txt (
  Stdlib::Fqdn              $domain,
  String                    $key,
  String                    $value,
  Optional[Bind::Zone::Ttl] $ttl = undef,
  Bind::Zone::Class         $class = 'IN',
) {

  $record_template_params = {
    key          => $key,
    ttl          => $ttl,
    record_class => $class,
    value        => $value
  }

  concat::fragment { "bind-zone-${domain}-a-${title}":
    order   => '90',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/txt.epp', $record_template_params),
  }
}
