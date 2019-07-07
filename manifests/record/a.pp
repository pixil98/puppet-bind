define bind::record::a (
  Stdlib::Fqdn                      $domain,
  Bind::Record::Host                $host,
  Optional[Bind::Zone::Ttl]         $ttl = undef,
  Bind::Zone::Class                 $class = 'IN',
  Stdlib::IP::Address::V4::Nosubnet $ip_address,
) {

  $record_template_params = {
    host         => $host,
    ttl          => $ttl,
    record_class => $class,
    ip_address   => $ip_address
  }

  concat::fragment { "bind-zone-${domain}-a-${title}":
    order   => '30',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/a.epp', $record_template_params),
  }
}
