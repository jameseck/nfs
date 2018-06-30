# ==Class: nfs::server::config
#
#
class nfs::server::config (
) {

  $nfs_sysconfig_options_erb = $::nfs::server::sysconfig_options

  file { $nfs::server::sysconfig_file:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
#    content => template('nfs/server/nfs_sysconfig.erb')
  }

  file { '/etc/modprobe.d/lockd.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  $lockd_port_ensure = $nfs::server::lockd_port ? {
    undef   => 'absent',
    default => 'present',
  }

  $statd_port_ensure = $nfs::server::statd_port ? {
    undef   => 'absent',
    default => 'present',
  }

  $mountd_port_ensure = $nfs::server::mountd_port ? {
    undef   => 'absent',
    default => 'present',
  }

  ['tcp', 'udp'].each |$p| {
    etcservices::service { "rpc.statd/${p}":
      ensure  => $statd_port_ensure,
      port    => $nfs::server::statd_port,
      comment => 'nfs rpc.statd',
    }

    etcservices::service { "rpc.mountd/${p}":
      ensure  => $mountd_port_ensure,
      port    => $nfs::server::mountd_port,
      comment => 'nfs rpc.mountd',
    }

    etcservices::service { "rpc.lockd/${p}":
      ensure  => $lockd_port_ensure,
      port    => $nfs::server::lockd_port,
      comment => 'nfs rpc.lockd',
    }

    file_line { "lockd ${p} port":
      ensure => $lockd_port_ensure,
      path   => '/etc/modprobe.d/lockd.conf',
      match  => "^(#)?options lockd nlm_${p}port.*$",
      line   => "options lockd nlm_udpport=${nfs::server::lockd_port}",
    }

    if ( $nfs::server::lockd_port != undef ) {
      sysctl { "fs.nfs.nlm_${p}port":
        ensure => $lockd_port_ensure,
        value  => $nfs::server::lockd_port,
        notify => Exec['nfs-server restart'],
      }
    }
  }

  $nfs::server::sysconfig_options.each |$k,$v| {
    file_line { "nfs sysconfig ${k}":
      path   => '/etc/sysconfig/nfs',
      match  => "^${k}=.*$",
      line   => "${k}=${v}",
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
