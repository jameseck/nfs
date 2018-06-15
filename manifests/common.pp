# ==Class: nfs::common
#
#
class nfs::common (
  String  $package_name   = undef,
  Enum[ 'present', 'installed', 'absent', 'purged', 'held', 'latest' ]
          $package_ensure = 'installed',
) {

  package { $nfs::common::package_name:
    ensure => $nfs::common::package_ensure,
  }

}
