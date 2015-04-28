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
  $deb         = undef,
  $fetch_url   = undef,
  $file_system = '/dev/vda1',
  $ra_bytes    = 2048,
  $swap_file   = '/swapfile',
  $time_zone   = 'US/Mountain',
) {

  class {'vertica::install':
    deb       => $deb,
    fetch_url => $fetch_url,
  }

  class {'vertica::config':
    file_system => $file_system,
    swap_file   => $swap_file,
    ra_bytes    => $ra_bytes,
    time_zone   => $time_zone,
  }

}
