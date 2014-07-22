class browsy::database(
  $user = 'vagrant',
  $db_name = 'browsy',
  $db_user = 'vagrant',
  ) {
  
  # ******************************************************
  # Postgresql
  # ******************************************************

  # remove any version of postgresql and purge its config files
  package {['postgresql-9.1', 'postgresql-9.2']:
    ensure => 'purged'
  }

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.3',
    encoding            => 'UTF8',
    locale              => 'en_US.utf8'
  }

  class { 'postgresql::server':
    encoding           => 'UTF8',
    locale             => 'en_US.utf8',
    postgres_password  => $db_user,
  }

  #postgresql::server::config_entry { 'port':
  #  value => '5432',
  #}

  exec { 'fix-psql-encoding':
    cwd       => "/home/${user}/browsy/puppet/scripts",
    command   => 'sh psqlfix.sh',
    logoutput => true,
    user      => $user,
    require   => Class['postgresql::server'],
    unless    => "psql template1 -c 'SHOW SERVER_ENCODING' | grep -q UTF8"
  }

  postgresql::server::role { $user:
    password_hash => postgresql_password($user,$user),
    createrole    => true,
    superuser     => true
  }



  # for rake db:create
  postgresql::server::database_grant { 'postgres':
    privilege => 'ALL',
    db        => 'postgres',
    role      => $user,
  }


  postgresql::server::db { $db_name:
    user     => $user,
    password => postgresql_password( $db_user, $db_user )
  }

  postgresql::server::db { 'browsy_test':
    user     => $user,
    password => postgresql_password( $db_user, $db_user)
  }

}
