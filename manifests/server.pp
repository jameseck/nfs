class nfs::server (
  Boolean $service_enable        = true,
  Enum[ 'true', 'false', 'running', 'stopped' ]
          $service_ensure        = 'running',
  Array   $service_list          = [],
  String  $nfs_service_name      = undef,
  String  $statd_service_name    = undef,
  Enum[ 'present', 'installed', 'absent', 'purged', 'held', 'latest' ]
          $package_ensure        = 'installed',
  Variant[String, Undef]
          $package_name          = undef,
  Stdlib::Absolutepath
          $sysconfig_file        = undef,
  Hash    $sysconfig_options     = {},
  Boolean $sysconfig_hash_lookup = false,
  Variant[Integer, Undef]
          $statd_port            = undef,
  Variant[Integer, Undef]
          $mountd_port           = undef,
  Variant[Integer, Undef]
          $lockd_port            = undef,
  Hash    $exports_hash          = {},
) {

  contain '::nfs::common'
  contain '::nfs::server::install'
  contain '::nfs::server::config'
  contain '::nfs::server::service'

  Class['nfs::common']
  -> Class['nfs::server::install']
  -> Class['nfs::server::config']
  ~> Class['nfs::server::service']

  if ( $exports_hash != {} ) {
    validate_hash($exports_hash)
    include '::nfs::server::export_setup'
    create_resources('nfs::server::export', $exports_hash)
  }

}
