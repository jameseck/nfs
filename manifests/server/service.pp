# ==Class: nfs::server::service
#
class nfs::server::service (
) {

  service { $nfs::server::nfs_service_name:
    ensure => $::nfs::server::service_ensure,
    enable => $::nfs::server::service_enable,
  }

  if ( $nfs::server::statd_service_name != undef ) {
    service { $nfs::server::nfs_service_name:
      ensure => $::nfs::server::service_ensure,
      enable => $::nfs::server::service_enable,
    }
  }

  service { $nfs::server::service_list:
    ensure => $::nfs::server::service_ensure,
    enable => $::nfs::server::service_enable,
  }

  # TODO: Fix this for multi OS support
  exec { 'nfs-server restart':
    command     => "systemctl restart ${nfs::server::nfs_service_name}",
    refreshonly => true,
  }

  # TODO: Fix this for multi OS support
  exec { 'statd restart':
    command     => "systemctl restart ${nfs::server::statd_service_name}",
    refreshonly => true,
  }
}
