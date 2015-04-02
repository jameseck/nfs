#====Define: nfs::server::export
#
#  This uses a template (exports.erb) and concat to build up each export entry.
#  You can pass a single client IP or an array of IP's.
#
#  This define also includes nfs::server, so this will manage the NFS service and notify exportfs when the
#  exports are modified.
#
#
#  Example Usage:
#
#  Export /home to 192.168.1.0/24 with (ro,async,no_root_squash) options:
#
#  nfs::server::export {'export /home to someone':
#    path    => '/home',
#    clients => '192.168.1.0/24',
#    options => 'ro,async,no_root_squash',
#  }
#
#  The order parameter is entirely optional and you probably won't need to use it, unless you want your exports to appear in
#  a particular order in /etc/exports.
#
#  The comment parameter is also optional and is really only there so you can be descriptive about the export if required.
#
define nfs::server::export (
  $path    = undef,
  $clients = undef,
  $options = 'ro',
  $order   = 50,
  $comment = 'Managed by Puppet'
) {

  validate_absolute_path($path)
  validate_array($clients)
  validate_string($options)
  if type($order) != 'integer' { fail("Not an integer in nfs::server::export define ${name}") }

  concat::fragment { "nfs export ${path} for ${clients}":
    target  => '/etc/exports',
    order   => $order,
    content => template('nfs/exports.erb'),
    notify  => Exec ['reload_exportfs_file'],
  }
}
