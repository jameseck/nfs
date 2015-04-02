# ==Class: nfs::server::install
#
#
class nfs::server::install (
) {

  case $::osfamily {
    #'RedHat': { $package_list = [ 'nfs-utils', ] } # Not required, should be handled by nfs::common
    'Debian': { $package_list = [ 'nfs-kernel-server' ] }
    default: { fail("osfamily ${::osfamily} is not supported.") }
  }

  package { $package_list:
    ensure => installed,
  }

}
