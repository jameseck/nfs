# ==Class: nfs::server::install
#
#
class nfs::server::install (
) {

  if ( $nfs::server::package_name != undef ) {
    package { $nfs::server::package_name:
      ensure => $nfs::server::package_ensure,
    }
  }

}
