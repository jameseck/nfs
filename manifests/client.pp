class nfs::client (
  $package_ensure = 'installed',
  $package_name   = undef,
) {

  validate_string($package_ensure)
  validate_string($package_name)

  if ( $package_ensure == undef ) {
    fail ('$package_ensure cannot be undef.')
  }

  if ( $package_name == undef ) {

    case $::osfamily {
      'RedHat': { $real_package_name = 'nfs-utils' }
      'Debian': { $real_package_name = 'nfs-common' }
      default: { fail("osfamily ${::osfamily} is not supported.") }
    }
  } else {
    $real_package_name = $package_name
  }

  package { $real_package_name:
    ensure => $package_ensure,
  }

}
