# == Defined type: check_mode
#
# This type allows to verify perms on files/directories
# that aren't puppet resources.  This is useful as 
# various cluster operations in vertica alter perms which
# causes cluster expansion/startup/recovery issues.
#
# === Examples
#
# check_mode { "/opt/vertica":
#   mode => 755,
# }
#
define vertica::check_mode($mode) {
  exec { "/bin/chmod -R ${mode} ${name}":
    onlyif => "test -e ${name}",
    path   => ['/usr/bin','/usr/sbin','/bin','/sbin'],
  }
}
