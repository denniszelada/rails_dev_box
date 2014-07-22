class credentials(
  $user = 'vagrant',
  $apply = true
  ){

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  }

  if $apply == true {
    file {"/home/${user}/.ssh":
      ensure => 'directory',
      owner   => $user,
      group   => $user,
    }->

    exec {'github-fingerprint':
      command => "ssh-keygen -f /home/${user}/.ssh/known_hosts -H -F github.com | grep -q found || ssh-keyscan -H github.com >> /home/${user}/.ssh/known_hosts",
      creates => "/home/${user}/.ssh/known_hosts",
      cwd     => "/home/${user}"
    }->

    file { 'ssh-config':
      path    =>"/home/${user}/.ssh/config",
      content => template("/home/${user}/browsy/puppet/templates/ssh_config"),
      owner   => $user,
      group   => $user,
    }->

    #exec {'credentials':
    #  command => "wget -O /home/${user}/.ssh/id_rsa https://s3.amazonaws.com/redtail/redtail_rsa && wget -O /home/${user}/.ssh/id_rsa.pub https://s3.amazonaws.com/redtail/redtail_rsa.pub",
    #  creates => "/home/${user}/.ssh/id_rsa.pub",
    #  cwd     => "/home/${user}",
    #}->


    file { 'root-ssh':
      ensure  => 'directory',
      path    => '/root/.ssh',
    }->

    exec{'copy-credentials':
      command => "cp /home/${user}/.ssh/* /root/.ssh/; true",
      creates => '/root/.ssh/id_rsa'
    }->

    exec {'change-owner':
      command => "chown ${user}:${user} -R /home/${user}/.ssh",
    }->

    exec {'change-mod':
      command => "chmod 700 -R /home/${user}/.ssh",
    }->

    exec {'change-mod-root':
      command => 'chmod 700 -R /root/.ssh',
    }

  }


}
