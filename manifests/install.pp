# Class: vertica::install
#
# This module manages vertica installation
#
class vertica::install(
  $fetch_url = undef,
  $build_ver = undef,
  $deb       = undef,
) {

   $tmp_dir = '/tmp/vertica'
   $latest_deb = "${tmp_dir}/${deb}"

   wget::fetch { "${fetch_url}/${build_ver}/${deb}":
     destination => $latest_deb,
     timeout     => 300,
     require     => File[$tmp_dir],
     before      => [File[$latest_deb], Package['install-deb']],
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
   }
}
