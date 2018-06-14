#====Class: nfs::server
#
#Class to ensure nfs server services are enabled and running.
#
# - Installs the nfs packages.
# - Keeps the nfs services running.
#
# === Parameters
#
# [*service_enable*]
#   The ensure state for the service resource.
#   Valid: running (default), stopped
#
# [*service_ensure*]
#   The enable state (whether the service should start on boot)
#    for the service resource.
#   Valid: true (default), false
#
# [*package_ensure*]
#   The ensure state for the package resources.
#
# [*nfs_sysconfig_options*]
#   A hash of options to put in the nfs sysconfig file.
#   This class will detect whether Debian/RedHat and
#   modify /etc/sysconfig/nfs or
#   /etc/default/nfs-kernel-server accordingly.
#
# [*nfs_sysconfig_hash_lookup*]
#   If you want this class to do a hiera_hash lookup,
#   set this option to true.
#   By default, a more specific hierarchy will override
#   the options.
#
# [*nfscommon_sysconfig_options*]
#   A hash of options to put in the nfs-common sysconfig file.
#   This option will only be effective on Debian variants.
#
# [*nfscommon_sysconfig_hash_lookup*]
#   If you want this class to do a hiera_hash lookup,
#   set this option to true.
#   By default, a more specific hierarchy will override
#   the options.
#
# [*lockd_udpport*]
#   Use this option to override the lockd udp port.
#   If this or the tcpport option is set, the class will
#   create /etc/modprobe.d/nfs.conf to override the ports.
#   You will have to restart the server or rmmod and modprobe
#   the lockd module for this to take effect.
#   If you set this option, you really should set the tcpport
#   option below as well.
#
# [*lockd_tcpport*]
#   See above option.
#
# [*exports*]
#   A hash of exports to be managed.
#
class nfs::server (
  Boolean $service_enable                  = true,
  Enum[ 'true', 'false', 'running', 'stopped' ]
          $service_ensure                  = 'running',
  Enum[ 'present', 'installed', 'absent', 'purged', 'held', 'latest' ]
          $package_ensure                  = 'installed',
  Variant[String, Undef]
          $package_name                    = undef,
  Hash    $nfs_sysconfig_options           = {},
  Boolean $nfs_sysconfig_hash_lookup       = false,
  Hash    $nfscommon_sysconfig_options     = {},
  Boolean $nfscommon_sysconfig_hash_lookup = false,
  Integer $lockd_udpport                   = undef,
  Integer $lockd_tcpport                   = undef,
  Hash    $exports_hash                    = {},
) {

  contain '::nfs::server::install'
  contain '::nfs::server::config'
  contain '::nfs::server::service'

  Class['nfs::server::install']
  -> Class['nfs::server::config']
  ~> Class['nfs::server::service']

  if ( $exports_hash != {} ) {
    validate_hash($exports_hash)
    include '::nfs::server::export_setup'
    create_resources('nfs::server::export', $exports_hash)
  }

}
