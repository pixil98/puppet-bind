define bind::record::aaaa (
  Stdlib::Fqdn              $domain,
  String                    $record_name,
  Optional[Bind::Zone::Ttl] $ttl = undef,
  Bind::Zone::Class         $class = 'IN',
  Stdlib::IP::Address::V6   $ip_address,
) {

  $record_template_params = {
    record_name  => $record_name,
    ttl          => $ttl,
    record_class => $class,
    ip_address   => $ip_address
  }

  concat::fragment { "bind-zone-record-aaaa-${title}":
    order   => '35',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/aaaa.epp', $record_template_params),
  }
}
