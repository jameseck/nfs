# ==Class: nfs::server::service
#
class nfs::server::service (
) {

  service { $nfs::server::service_list:
    ensure => $::nfs::server::service_ensure,
    enable => $::nfs::server::service_enable,
  }

}
