class svmp_server::params {
    $user          = 'svmp'
    $group         = 'svmp'
    $conf_dir      = '/etc/svmp-server'
    $conf_file     = 'config-local.yaml'
    $conf_template = 'svmp_server/config-local.yaml.erb'
    $service_name  = 'svmp-server'

    $port   = 8080

    # SSL options
    $enable_ssl         = false

    # User authentication options
    $cert_user_auth       = false
    $behind_reverse_proxy = false

    $log_dir       = '/var/log/svmp'
    $log_file      = 'svmp-server.log'
    $log_level     = 'info'
    $log_filter    = [ 'SENSOREVENT', 'TOUCHEVENT' ]

    $version  = 'svmp-2.0.0'
    #$npm_name = 'git+https://github.com/SVMP/svmp-server'
    $npm_name = 'SVMP/svmp-server'

}
