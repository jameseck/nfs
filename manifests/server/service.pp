# ==Class: nfs::server::service
#
class nfs::server::service (
) {

  case $::osfamily {
    'Debian': {
      case $::operatingsystemrelease {
        /^12.04.*/: { $service_list = [ 'nfs-kernel-server', 'portmap' ] }
        /^14.04.*/: { $service_list = [ 'nfs-kernel-server', 'rpcbind' ] }
        default: { fail("operatingsystemrelease ${::operatingsystemrelease} not supported") }
      }
    }
    'RedHat': {
        case $::operatingsystemrelease {
          /^6.*/: { $service_list = [ 'rpcbind', 'nfs', 'nfslock' ] }
          /^5.*/: { $service_list = [ 'nfs', 'nfslock', 'portmap' ] }
          /^7.*/: { $service_list = [ 'nfs-idmap', 'nfs-lock', 'nfs-mountd', 'nfs-rquotad', 'nfs-server', ] }
          default: { fail("operatingsystemrelease ${::operatingsystemrelease} not supported") }
        }
    }
    default: { fail("osfamily ${::osfamily} is not supported") }
  }

  service { $service_list:
    ensure => $::nfs::server::service_ensure,
    enable => $::nfs::server::service_enable,
  }

}
