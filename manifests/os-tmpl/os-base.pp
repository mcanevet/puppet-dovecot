# Requires:
#

class os-base {

  include os
  include ssh
  include apt
  include augeas
  include c2c::sysadmin-in-charge-new
  include c2c::skel
  include sudo::base
  include puppet::client
  include apt::unattended-upgrade::automatic

  apt::sources_list {"puppet-0.25":
    ensure => present,
    content => "# file managed by puppet
deb http://dev.camptocamp.com/packages ${lsbdistcodename} puppet-0.25 
deb-src http://dev.camptocamp.com/packages ${lsbdistcodename} puppet-0.25
",
  }

  apt::preferences {["augeas-lenses","augeas-tools", "libaugeas0"]:
    ensure => present,
    pin => "version ${augeas_version}",
    priority => 1100,
  }

  apt::preferences {"facter":
    ensure => present,
    pin => "version ${facter_version}",
    priority => 1100,
  }

  package {["puppet-common","vim-puppet", "puppet-el"]:
    ensure => $puppet_client_version,
  }

  apt::preferences {["puppet", "puppet-common","vim-puppet", "puppet-el"]:
    ensure => present,
    pin => "version ${puppet_client_version}",
    priority => 1100,
  }

  augeas {"sshd/AuthorizedKeysFile":
    context => "/files/etc/ssh/sshd_config/",
    changes => "set AuthorizedKeysFile %h/.ssh/authorized_keys",
    notify => Service["ssh"],
  }

  file {"/etc/ssh/authorized_keys":
    ensure => absent,
    purge => true,
    force => true,
  }

}

