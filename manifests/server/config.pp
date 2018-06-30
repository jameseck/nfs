# ==Class: nfs::server::config
#
#
class nfs::server::config (
) {

  $nfs_sysconfig_options_erb = $::nfs::server::sysconfig_options

  file { $nfs::server::sysconfig_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nfs/server/nfs_sysconfig.erb')
  }

  ['tcp', 'udp'].each |$p| {
    etcservices::service { "rpc.statd/${p}":
      port    => $nfs::server::statd_port,
      comment => 'nfs rpc.statd',
    }

    etcservices::service { "rpc.mountd/${p}":
      port    => $nfs::server::mountd_port,
      comment => 'nfs rpc.mountd',
    }

    etcservices::service { "rpc.lockd/${p}":
      port    => $nfs::server::lockd_port,
      comment => 'nfs rpc.lockd',
    }

    file_line { "lockd ${p} port":
      path  => '/etc/modprobe.d/lockd.conf',
      match => "^(#)?options lockd nlm_${p}port.*$",
      line  => "options lockd nlm_udpport=${nfs::server::lockd_port}",
    }

    sysctl { "fs.nfs.nlm_${p}port":
      ensure => present,
      value  => $nfs::server::lockd_port,
      notify => Exec['nfs-server restart'],
    }
  }

  file_line { 'nfs statd port':
    path   => '/etc/sysconfig/nfs',
    match  => '^STATD_PORT=.*$',
    line   => "STATD_PORT=${nfs::server::statd_port}",
    notify => Exec['statd restart'],
  }

  file_line { 'nfs mountd port':
    path   => '/etc/sysconfig/nfs',
    match  => '^MOUNTD_PORT=.*$',
    line   => "MOUNTD_PORT=${nfs::server::mountd_port}",
    notify => Exec['nfs-server restart'],
  }

}
