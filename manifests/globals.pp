# globals.pp 

# Puppet configuration
$puppet_server = "pm.camptocamp.net"
$puppet_reportserver = "pm.camptocamp.net"

case $operatingsystem {
  /Debian|Ubuntu/: {
    $puppet_client_version = "0.25.5-1~c2c+1"
    $puppet_server_version = "0.25.5-1~c2c+1"
    $facter_version = "1.5.7-1~c2c+3"
    case $lsbdistcodename {
      lenny:    { $augeas_version = "0.7.0-1~bpo50+1" }
      lucid:    { $augeas_version = "0.7.0-1ubuntu1" }
    }
  }
  /CentOS|RedHat/: {
    $puppet_client_version = "0.25.5-1.el${lsbmajdistrelease}"
    $facter_version = "1.5.8-1.el${lsbmajdistrelease}"
    $augeas_version = "0.7.2-2.el${lsbmajdistrelease}"
  }

}

# fist uid/gid used by type user (provider=adduser)
# sadb 1000 -> 19999
# others 2000 -> MAX
$adduser_first_uid = "2000"
$adduser_first_gid = "2000"

$ldap_uri = "ldap://ldap.lsn.camptocamp.com ldap://ldap.cby.camptocamp.com"
$ldap_base = "dc=ldap,dc=c2c"
$openvz_kernel_version = "2.6.18"

$sites = "/etc/apache2/sites"
$mods = "/etc/apache2/mods"
$pam_config_dir = "/etc/pam.d"
$sig_packages_release = "20080225"
$smart_host = "mail.camptocamp.com"
$sadb = "http://sadb.camptocamp.com"

# EPSG configuration
$epsg_file = "minimal"

Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" }

filebucket { main: server => $puppet_server }

# global defaults
File {
  backup => main,
  ignore => ['.svn', '.git', '.bzr'],
  owner  => root,
  group  => root,
  mode   => 0644,
}

$osdist = "${operatingsystem}-${lsbdistcodename}"

Package {
  provider => $operatingsystem ? {
    debian => apt,
    ubuntu => apt,
    redhat => yum,
    centos => yum
  },
}
case $operatingsystem {
  /Debian|Ubuntu/: { Package { require => Exec["apt-get_update"] } }
  default : {}
}

if $lsbdistid == "Debian" {
  # Set first UID/GID
  Group {require => File["/etc/adduser.conf"]}
  User {require => File["/etc/adduser.conf"]}
}

## openerp settings
$openerp_db_name = ""
$openerp_db_user = "openerp-demo-camptocamp"
$openerp_db_password = "openerp-demo-camptocamp"
$openerp_db_host = "localhost"
$openerp_db_port = "5432"
$openerp_verbose = "False"
$openerp_pidfile = "/var/run/openerp.pid"
$openerp_logfile = "/var/log/openerp.log"
$openerp_interface = "localhost"
$openerp_port = "8069"
$openerp_netport = "8070"
$openerp_debug_mode = "False"
$openerp_secure = "False"
$openerp_smtp_server = "localhost"
$openerp_smtp_user = "False"
$openerp_smtp_password = "False"
## special things for openerp-sources
$openerp_source_owner = "openerp"
$openerp_source_group = "openerp"
## openerp web client settings
$openerp_web_port = "8080"
$openerp_web_environment = "production"
$openerp_web_protocol = "https"
$openerp_web_passwrd = "openerp-demo-camptocamp"
$openerp_web_baseurl = "http://tinyerp.camptocamp.com/"
$openerp_web_sockhost = "0.0.0.0"
## nagios default hostgroup
$hostgroup = "ovz-host"
