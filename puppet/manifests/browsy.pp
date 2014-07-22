class browsy(
  $user = 'vagrant',
  $port = 3000,
  $environment = 'development',
  $application = 'browsy',
  $app_dir     = 'browsy',
  $pid         = 'server.pid',
  $procfile    = 'Profile',
  $type        = 'catalog',
  $server      = ['192.168.0.38:5001'],
  $browsy_host = undef,
  ) {

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  }


  if ($environment == 'development') {
    $working_dir       = "/home/vagrant/browsy"
    $apply_credentials = true
    $gemfile_path      = "/home//vagrant/browsy/Gemfile"
    $gem_path          = "/home/${user}/.gem"
  } else {
    $working_dir       = "/home/${user}/${app_dir}"
    $apply_credentials = true
    $gemfile_path      = "/home/${user}/${app_dir}/Gemfile"
    $gem_path          = "/home/${user}/.gem"
  }

  import "credentials.pp"
  import "database.pp"
  import 'utils.pp'
  import 'application.pp'

  include 'wget'

  if ($environment == 'development') {
    package { 'redis-server':
      ensure => installed,
    }
  }


  package {['imagemagick',
            'libpq-dev',
            'beanstalkd',
            'build-essential',
            'tmux',
            'tig',
            'emacs']:
    ensure => installed,
  }


  class { 'apt':
  }

  class { 'bluekite_ruby':
  }->  # use 2.0

  exec { 'update-ruby-gems':
    command       => 'gem update --system',
    logoutput => true,
  }->

  exec { 'update-rake':
    command       => 'gem update rake',
    logoutput => true,
  }->

  class {'browsy::database':
    user => $user
  }->


  # ******************************************************
  # Browsy API
  # ******************************************************
  class {'credentials':
    user  => $user,
    apply => $apply_credentials,
  }->

  package {'bundler':
    ensure   => installed,
    provider => gem,
  }->

  class { 'application':
    environment  => $environment,
    port         => $port,
    working_dir  => $working_dir,
    user         => $user,
    application  => $application,
    gemfile_path => $gemfile_path,
    pid          => $pid,
    procfile     => $procfile,
    apply        => true,
    browsy_host => $browsy_host,
  }


}
