define bind::record::a (
  Stdlib::Fqdn             $domain,
  String                   $record_name,
  Optional[String]         $ttl = undef,
  Bind::Zone::Class        $class = 'IN',
  Stdlib::IP::Address::V4  $ip_address,
) {

  $record_template_params = {
    record_name  => $record_name,
    ttl          => $ttl,
    record_class => $class,
    ip_address   => $ip_address
  }

  concat::fragment { "bind-zone-record-a-${title}":
    order   => '30',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/a.epp', $record_template_params),
  }
}
