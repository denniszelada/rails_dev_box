class application (
  $environment  = 'development',
  $port         = 3000,
  $working_dir  = '/vagrant',
  $user         = 'vagrant',
  $application  = 'browsy',
  $gemfile_path = '/vagrant',
  $pid          = 'server.pid',
  $procfile     = 'Procfile',
  $apply        = true,
  $browsy_host = undef,
  ){

  if ($apply == true) {

    # setup foreman upstart command
    if ($environment == 'development') {
      $env_file = '.env-vagrant'
      $gems_path = '~/.gem'
    } else {
      $env_file = '.env-aws'
      $gems_path = 'vendor/bundle'
    }
    $upstart_command = "bundle exec foreman export upstart --app ${application} --user root --env ${env_file} --procfile ${procfile} /etc/init"


    if ($environment == 'development') {
      $configure_foreman = true
      if ($browsy_host == undef) {
        $host     = "${ipaddress_eth1}:${port}"
      } else {
        $host     = $ipaddress
      }
    } else {
      $configure_foreman = false
      if ($browsy_host == undef) {
        $host     = $ipaddress
      } else {
        $host  = $browsy_host
      }
    }

    import 'foreman.pp'

    file { 'application-environment':
      path    => '/etc/environment',
      content => inline_template( "RAILS_ENV=${environment}\nRAILS_PID=tmp/pids/${pid}\nBROWSY_PORT=${port}\nBROWSY_DEFAULT_HOST=http://${host}\nBROWSY_GATEWAY=${gateway}" )
    }->

    exec { 'browsy-bundle-install':
      command     => "bundle install --path ${gems_path}",
      cwd         => $working_dir,
      unless      => 'bundle check',
      user        => $user,
      group       => $user,
      logoutput   => true,
      timeout     => 1800,
      environment => "HOME=/home/${user}"
    }->
    
    exec { 'browsy-foreman_service':
      command     => $upstart_command,
      cwd         => $working_dir,
      environment => "HOME=/home/${user}",
      require  => [ Exec['browsy-bundle-install'] ]
    }->

    foreman::upstart { '/etc/init/browsy-restart.conf':
      user  => 'root',
      apply => $configure_foreman,
    }->

    service { $application:
      ensure   => running,
      provider => 'upstart',
      require  => [ Exec['browsy-foreman_service'] ]
    }

  } # apply?

} # class application
