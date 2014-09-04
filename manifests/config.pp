class svmp_server::config inherits svmp_server {
    file { $conf_file:
        path    => "${conf_dir}/${conf_file}",
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '640',
        content => template($conf_template),
        require => File[$conf_dir],
        notify  => Service[$service_name],
    }

    #  file { '/etc/init.d/svmp_server':
    #    ensure => file,
    #    owner  => 'root',
    #    group  => 'root',
    #    mode   => '755',
    #    content => template('svmp_server/svmp-init.erb'),
    #  }
}
