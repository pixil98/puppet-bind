define bind::record::aaaa (
  Stdlib::Fqdn             $domain,
  String                   $record_name,
  Optional[String]         $ttl = undef,
  Bind::Zone::Class        $class = 'IN',
  Stdlib::IP::Address::V6  $ip_address,
) {

  $record_template_params = {
    record_name  => $record_name,
    ttl          => $ttl,
    record_class => $class,
    ip_address   => $ip_address
  }

  concat::fragment { "bind-zone-record-aaaa-${title}":
    order    => '35',
    target   => "bind-zone-${domain}",
    condtent => epp('bind/record/a.epp', $record_template_params),
  }
}
