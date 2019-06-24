class bind (
  # Installer
  String                               $package_name,
  String                               $package_ensure,
  Boolean                              $package_manage,
  # Service
  String                               $service_name,
  # Configuration
  Stdlib::Absolutepath                 $config_dir,
  String                               $bind_user,
  String                               $bind_group,
  Boolean                              $validate_config,
  Boolean                              $manage_zones = true,
  # Options
  Optional[Array[Bind::Address_match]] $allow_recursion = undef,
  Optional[Array[Bind::Address_match]] $allow_transfer = undef,
  Optional[Enum['yes', 'no']]          $auth_nxdomain = undef,
  Optional[Enum['yes', 'no', 'auto']]  $dnssec_validation = undef,
  Stdlib::Absolutepath                 $directory,
  Optional[Enum['yes', 'no']]          $empty_zones_enable = undef,
  Optional[Array[Bind::Address_match]] $forwarders = undef,
  Optional[Stdlib::Absolutepath]       $key_directory = undef,
  Optional[Array[Bind::Address_match]] $listen_on = undef,
  Optional[Array[Bind::Address_match]] $listen_on_v6 = undef,
  Optional[Bind::Rate_limit]           $rate_limit = undef,
  Optional[Variant[Boolean, String]]   $version = undef,
) {
  if !lookup('bind::supported')  {
    fail('Bind is not supported on your OS')
  }

  contain bind::install
  contain bind::config
  contain bind::service

  Class['::bind::install']
  -> Class['::bind::config']
  ~> Class['::bind::service']
}
