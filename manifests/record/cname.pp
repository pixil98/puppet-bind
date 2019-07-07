define bind::record::cname (
  Stdlib::Fqdn              $domain,
  Stdlib::Fqdn              $host,
  Optional[Bind::Zone::Ttl] $ttl = undef,
  Bind::Zone::Class         $class = 'IN',
  Stdlib::Fqdn              $canonical_name,
) {

  $record_template_params = {
    host           => $host,
    ttl            => $ttl,
    record_class   => $class,
    canonical_name => $canonical_name,
  }

  concat::fragment { "bind-zone-${domain}-cname-${title}":
    order   => '40',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/cname.epp', $record_template_params),
  }
}
