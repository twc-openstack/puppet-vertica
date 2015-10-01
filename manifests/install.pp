# Class: vertica::install
#
# This module manages vertica installation
#
class vertica::install(
  $console_deb = undef,
  $deb         = undef,
  $fetch_url   = undef,
) {

   $tmp_dir = '/tmp/vertica'
   $latest_deb = "${tmp_dir}/${deb}"
   $latest_console_deb = "${tmp_dir}/${console_deb}"

   wget::fetch { "${fetch_url}/${deb}":
     destination => $latest_deb,
     timeout     => 300,
     require     => File[$tmp_dir],
     before      => [File[$latest_deb], Package['install-deb']],
   }

   wget::fetch { "${fetch_url}/${console_deb}":
     destination => $latest_console_deb,
     timeout     => 300,
     require     => File[$tmp_dir],
     before      => [File[$latest_console_deb], Package['install-console-deb']],
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

   file { $latest_console_deb:
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

   package { 'vertica-console':
     ensure   => latest,
     provider => dpkg,
     source   => $latest_console_deb,
     alias    => 'install-console-deb',
   }

   # Work-around vertica packaging issue which leaves logrotation non-working
   file { '/opt/vertica/config/logrotate/agent.logrotate':
     owner   => 'root',
     group   => 'root',
     mode    => '0644',
     require => Package['vertica'],
   }

   # Work-around vertica packaging issue which leaves logrotation non-working
   file { '/opt/vertica/config/logrotate/mon':
     owner   => 'root',
     group   => 'root',
     mode    => '0644',
     require => Package['vertica-console'],
   }
}
