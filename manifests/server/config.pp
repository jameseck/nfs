# ==Class: nfs::server::config
#
#
class nfs::server::config (
) {

  if ( $::nfs::server::nfs_sysconfig_hash_lookup == true ) {
    $nfs_sysconfig_options_erb = hiera_hash('nfs::server::nfs_sysconfig_options')
  } else {
    $nfs_sysconfig_options_erb = $::nfs::server::nfs_sysconfig_options
  }

  case $::osfamily {
    'RedHat': { $nfs_sysconfig_file = '/etc/sysconfig/nfs' }
    'Debian': { $nfs_sysconfig_file = '/etc/default/nfs-kernel-server' }
    default: { fail("osfamily ${::osfamily} is not supported.") }
  }

  file { $nfs_sysconfig_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nfs/server/nfs_sysconfig.erb')
  }

  # Only Debian variants have the /etc/default/nfs-common file
  if ( $::osfamily == 'Debian' ) {
    if ( $::nfs::server::nfscommon_sysconfig_hash_lookup == true ) {
      $nfscommon_sysconfig_options_erb = hiera_hash('nfs::server::nfscommon_sysconfig_options')
    } else {
      $nfscommon_sysconfig_options_erb = $::nfs::server::nfscommon_sysconfig_options
    }

    file { '/etc/default/nfs-common':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('nfs/server/nfscommon_sysconfig.erb')
    }

    # If we specify a non-default lockd_udpport or lockd_tcpport, create the
    # modprobe.d file.
    # Note that the server will need to be rebooted, or you'll have to rmmod and
    # modprobe lockd for this option to take effect
    if ( $::nfs::server::lockd_udpport != undef or $::nfs::server::lockd_tcpport != undef ) {
      $erb_nfs_lockd_udpport = $::nfs::server::lockd_udpport
      $erb_nfs_lockd_tcpport = $::nfs::server::lockd_tcpport

      file { '/etc/modprobe.d/nfs.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('nfs/server/modprobe.d_nfs.conf.erb'),
      }
    } else {
      file { '/etc/modprobe.d/nfs.conf':
        ensure => absent,
      }
    }
  }

}
