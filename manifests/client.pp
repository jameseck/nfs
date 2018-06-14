class nfs::client (
  Enum[ 'present', 'installed', 'absent', 'purged', 'held', 'latest' ]
    $package_ensure = 'installed',
  Variant[String, Undef]
    $package_name   = undef,
) {

  if ( $package_name != undef ) {
    package { $package_name:
      ensure => $package_ensure,
    }
  }

}
