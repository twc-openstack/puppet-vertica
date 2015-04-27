# == Class: vertica
#
# This module installs and configures the vertica database
#
# === Parameters
#
# Document parameters here.
#
# === Examples
#
#  class { 'vertica':
#  }
#
class vertica (
  $build_ver   = undef,
  $fetch_url   = undef,
  $file_system = '/dev/vda1',
  $deb         = undef,
  $swap_file   = '/swapfile',
) {

  class {'vertica::install':
    fetch_url => $fetch_url,
    build_ver => $build_ver,
    deb       => $deb,
  }

  class {'vertica::config':
    file_system => $file_system,
    swap_file   => $swap_file,
  }

}
