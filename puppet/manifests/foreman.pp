define foreman::upstart(
  $upstart = $title,
  $user    = 'root',
  $log     = undef,
  $apply   = true
  ) {

  if ($apply == true) {
    $str = "
    start on vagrant-mounted

    expect fork

    pre-start script
    end script

    script
       service browsy restart
    end script
    "

    file { $upstart:
      ensure  => file,
      content => $str,
    }
  } # if apply?
}
