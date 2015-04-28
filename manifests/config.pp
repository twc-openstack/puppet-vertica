# Class: vertica::config
#
# This module configures users and groups for vertica
#
class vertica::config(
  $file_system = undef,
  $swap_file = undef,
  $ra_bytes = undef,
) {

  $dba_group = 'verticadba'

  group { $dba_group:
    ensure => present,
  }

  user { 'dbadmin':
    ensure     => present,
    groups     => $dba_group,
    managehome => true,
    shell      => '/bin/bash',
    require    => Group[$dba_group],
  }

  user { 'mcadmin':
    ensure     => present,
    groups     => $dba_group,
    managehome => true,
    shell      => '/bin/bash',
    require    => Group[$dba_group],
  }

  exec { "Ensure read ahead is set to ${ra_bytes} bytes":
    command => "blockdev --setra ${ra_bytes} ${file_system}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/tmp',
    user    => 'root',
    group   => 'root',
  }

  exec { "Ensure read ahead command is in /etc/rc.local":
    command => "sed -i 's#^exit 0#blockdev --setra ${ra_bytes} ${file_system}\\n\0#' /etc/rc.local",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/tmp',
    user    => 'root',
    group   => 'root',
    onlyif  => "grep -q 'blockdev --setra ${ra_bytes} ${file_system}' /etc/rc.local; test $? -ne 0",
  }

  exec { "Ensure ${swap_file} exists":
    command => "dd if=/dev/zero of=${swap_file} bs=1024 count=2097152 && mkswap ${swap_file} && swapon ${swap_file}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/tmp',
    user    => 'root',
    group   => 'root',
    onlyif  => "test -f ${swap_file}; test $? -ne 0",
  }

  exec { "Ensure ${swap_file} is in fstab":
    command => "echo '${swap_file} none swap sw 0 0' >> /etc/fstab",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/tmp',
    user    => 'root',
    group   => 'root',
    onlyif  => "grep -q '${swap_file}' /etc/fstab; test $? -ne 0",
  }

}
