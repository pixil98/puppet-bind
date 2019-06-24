type Bind::Rate_limit = Struct[{
  Optional[responses-per-second] => Integer,
  Optional[referrals-per-second] => Integer,
  Optional[nodata-per-second]    => Integer,
  Optional[nxdomains-per-second] => Integer,
  Optional[errors-per-second]    => Integer,
  Optional[all-per-second]       => Integer,
  Optional[window]               => Integer,
  Optional[log-only]             => Enum['yes', 'no'],
  Optional[qps-scale]            => Integer,
  Optional[ipv4-prefix-length]   => Integer,
  Optional[ipv6-prefix-length]   => Integer,
  Optional[slip]                 => Integer,
  Optional[exempt-clients]       => Array[Bind::Address_match],
  Optional[max-table-size]       => Integer,
  Optional[min-table-size]       => Integer,
}]

