$ar_databases = ['activerecord_unittest', 'activerecord_unittest2']
$as_vagrant   = 'su - vagrant -c'
$home         = '/home/vagrant'
$source_rvm   = 'source ~/.rvm/scripts/rvm &&'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }
}
class { 'apt_get_update':
  stage => preinstall
}

# --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# --- Ruby ----------------------------------------------------------------------

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  require => Package['curl']
}

exec { 'install_ruby':
  command => "${as_vagrant} '${source_rvm} rvm install 2.0.0-p353'",
  require => Exec['install_rvm']
}

# --- Gems ----------------------------------------------------------------------

exec { 'install_bundler':
  command => "${as_vagrant} '${source_rvm} gem install bundler --no-rdoc --no-ri'",
  require => Exec['install_ruby']
}