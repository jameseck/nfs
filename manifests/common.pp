class nfs::common (
) {

  case $::osfamily {
    'RedHat': { $package_list = [ 'nfs-utils', ] }
    'Debian': { $package_list = [ 'nfs-common' ] }
    default: { fail("osfamily ${::osfamily} is not supported.") }
  }

  package { $package_list:
    ensure => installed,
  }

}
