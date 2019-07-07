define bind::record::ns (
  Stdlib::Fqdn              $domain,
  Bind::Record::Host        $owner_name = '@',
  Optional[Bind::Zone::Ttl] $ttl = undef,
  Bind::Zone::Class         $class = 'IN',
  Stdlib::Fqdn              $name_server,
) {

  $record_template_params = {
    owner_name   => $owner_name,
    ttl          => $ttl,
    record_class => $class,
    name_server  => $name_server
  }

  concat::fragment { "bind-zone-${domain}-ns-${title}":
    order   => '10',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/ns.epp', $record_template_params),
  }
}
