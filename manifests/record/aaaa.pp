define bind::record::aaaa (
  Stdlib::Fqdn                      $domain,
  Bind::Record::Host                $host,
  Optional[Bind::Zone::Ttl]         $ttl = undef,
  Bind::Zone::Class                 $class = 'IN',
  Stdlib::IP::Address::V6::Nosubnet $ip_address,
) {

  $record_template_params = {
    host         => $host,
    ttl          => $ttl,
    record_class => $class,
    ip_address   => $ip_address
  }

  concat::fragment { "bind-zone-${domain}-aaaa-${title}":
    order   => '35',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/aaaa.epp', $record_template_params),
  }
}
