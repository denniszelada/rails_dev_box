import 'browsy.pp'

class { 'browsy':
  user        => 'vagrant',
  environment => 'development',
  application => 'browsy',
  app_dir     => 'browsy',
  pid         => 'browsy.pid',
  procfile    => 'Procfile-browsy',
  port        => 3000
}
