import 'browsy.pp'

class { 'browsy':
  user        => 'ubuntu',
  environment => 'staging',
  application => 'browsy',
  app_dir     => 'browsy',
  pid         => 'browsy.pid',
  procfile    => 'Procfile-browsy',
  port        => 3000
}
