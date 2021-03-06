define bind::record::soa (
  Stdlib::Fqdn              $domain,
  Stdlib::Fqdn              $name_server,
  String                    $email,
  Integer                   $serial,
  Bind::Zone::Ttl           $refresh,
  Bind::Zone::Ttl           $retry,
  Bind::Zone::Ttl           $expire,
  Bind::Zone::Ttl           $minttl,
  Bind::Zone::Class         $class = 'IN',
  Optional[Bind::Zone::Ttl] $ttl = undef,
) {

  if !is_email_address($email) {
    fail("Invalid email address: ${email}")
  }

  $record_template_params = {
    record_class => $class,
    name_server  => $name_server,
    email        => regsubst($email, '@', '.'),
    serial       => $serial,
    refresh      => $refresh,
    retry        => $retry,
    expire       => $expire,
    minttl       => $minttl,
    ttl          => $ttl,
  }

  concat::fragment { "bind-zone-${domain}-soa":
    order   => '10',
    target  => "bind-zone-${domain}",
    content => epp('bind/record/soa.epp', $record_template_params),
  }
}
