define bind::acl (
  Array[Bind::Address_match] $address_match_list,
) {
  concat::fragment { "bind-acl-${title}":
    order   => '10',
    target  => 'bind-named-conf-acls',
    content => epp('bind/acl.epp', { 'acl_name' => $name, 'address_match_list' => $address_match_list }),
  }
}
