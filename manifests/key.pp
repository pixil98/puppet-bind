define bind::key (
  String               $secret,
  Bind::Key::Algorithm $algorithm = 'hmac-sha512',
) {

  # == Validate params ==

  # == Key declaration ==
  $key_template_params = {
    key_name  => $name,
    algorithm => $algorithm,
    secret    => $secret,
  }

  concat::fragment { "bind-key-config-${title}":
    order   => '10',
    target  => 'bind-named-conf-keys',
    content => epp('bind/key.epp', $key_template_params),
  }
}
