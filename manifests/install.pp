class svmp_server::install inherits svmp_server {
    # Set up the SVMP group and user
    validate_bool($manage_group)
    if $manage_group {
        group { $group:
            ensure => present,
            system => true,
        }
    }

    validate_bool($manage_user)
    if $manage_user {
        user { $user:
            ensure => present,
            gid    => $group,
            system => true,
        }
    }

    package { "${npm_name}#${version}":
#      ensure   => $version,
      ensure   => present,
      provider => 'npm',
    }

    file { $conf_dir:
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => '750',
        require => [ User[$user], Group[$group], ],
    }

    file { $log_dir:
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => '750',
        require => [ User[$user], Group[$group], ],
    }

}
