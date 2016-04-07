# Class: vertica::install
#
# This module manages vertica installation
#
class vertica::install(
  $console_deb     = undef,
  $deb             = undef,
  $fetch_url       = undef,
  $install_console = false,
) {

   $tmp_dir = '/tmp/vertica'
   $latest_deb = "${tmp_dir}/${deb}"

   wget::fetch { "${fetch_url}/${deb}":
     destination => $latest_deb,
     timeout     => 300,
     require     => File[$tmp_dir],
     before      => [File[$latest_deb], Package['install-deb']],
   }

   if $install_console {
     $latest_console_deb = "${tmp_dir}/${console_deb}"
     wget::fetch { "${fetch_url}/${console_deb}":
       destination => $latest_console_deb,
       timeout     => 300,
       require     => File[$tmp_dir],
       before      => [File[$latest_console_deb], Package['install-console-deb']],
     }

     file { $latest_console_deb:
       ensure => present,
     }
     package { 'vertica-console':
       ensure   => latest,
       provider => dpkg,
       source   => $latest_console_deb,
       alias    => 'install-console-deb',
     }

   } else {
     package { 'vertica-console':
       ensure   => absent,
       provider => dpkg,
     }
   }

   file { $tmp_dir:
     ensure => 'directory',
     owner  => 'root',
     group  => 'root',
     mode   => '0755',
   }

   file { $latest_deb:
     ensure => present,
   }

   tidy { $tmp_dir:
     matches => 'vertica*.deb',
     recurse => true,
   }

   package { 'vertica':
     ensure   => latest,
     provider => dpkg,
     source   => $latest_deb,
     alias    => 'install-deb',
     require  => Package['dialog'],
   }

}
