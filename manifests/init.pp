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
  $console_deb       = undef,
  $deb               = undef,
  $db_admin_password = undef,
  $fetch_url         = undef,
  $lang              = 'en_US.UTF-8',
  $mc_admin_password = undef,
  $ra_bytes          = 2048,
  $swap_file         = '/swapfile',
  $time_zone         = 'US/Mountain',
) {

  class {'vertica::install':
    console_deb => $console_deb,
    deb         => $deb,
    fetch_url   => $fetch_url,
  }

  class {'vertica::config':
    db_admin_password => $db_admin_password,
    lang              => $lang,
    mc_admin_password => $mc_admin_password,
    ra_bytes          => $ra_bytes,
    swap_file         => $swap_file,
    time_zone         => $time_zone,
  }

}
