class nfs::server::export_setup (
) {

  #You don't actually reload the NFS service when an export changes,
  # you use the exportfs command. This Exec should be notified when adding
  # or removing lines to /etc/exportfs
  exec { 'reload_exportfs_file':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => 'exportfs -r',
    refreshonly => true,
  }

  # Set up the initial export file properties
  concat{ '/etc/exports':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['reload_exportfs_file']
  }

  # Add a header (just a comment that shows the file is managed by Puppet)
  concat::fragment{'exports_header':
    target  => '/etc/exports',
    content => "#### Puppet manages this file! ####\n\n",
    order   => 10,
  }

}
