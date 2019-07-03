define bind::record::soa (
  Stdlib::Fqdn              $domain,
  Stdlib::Fqdn              $name_server,
  String                    $email,
  Integer                   $serial,
  Bind::Zone::Ttl           $refresh,
  Bind::Zone::Ttl           $retry,
  Bind::Zone::Ttl           $expiry,
  Bind::Zone::Ttl           $nxdomainttl,
  Bind::Zone::Class         $class = 'IN',
  Optional[Bind::Zone::Ttl] $ttl = undef,
) {

  if !is_valid_email($email) {
    fail("Invalid email address: ${email}")
  }
  $email = regsubst($email, '@', '.')
  $email = "${email}."

  $record_template_params = {
    record_class => $class,
    name_server  => $name_server,
    email        => $email,
    serial       => $serial,
    refresh      => $refresh,
    retry        => $retry,
    expiry       => $expiry,
    nxdomainttl  => $nxdomainttl,
    ttl          => $ttl,
  }

  concat::fragment { "bind-zone-${domain}-soa":
    order   => '10',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/soa.epp', $record_template_params),
  }
}
