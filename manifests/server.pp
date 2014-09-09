# == Class: svmp::server
#
# === Copyright
#
# Copyright (c) 2012-2014, The MITRE Corporation, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class svmp::server (
    $server_port   = $::svmp::server::params::port,

    # Overseer API server configuration
    $overseer_url,
    $overseer_cert,
    $auth_token,

    # SSL options
    $enable_ssl   = false,
    $ssl_cert     = undef,
    $ssl_key      = undef,
    $ssl_key_pass = undef,
    $ssl_ca       = undef,

    # User authentication options
    $cert_user_auth       = $::svmp::server::params::cert_user_auth,
    $behind_reverse_proxy = $::svmp::server::params::behind_reverse_proxy,

    $log_dir       = $::svmp::server::params::log_dir,
    $log_file      = $::svmp::server::params::log_file,
    $log_level     = $::svmp::server::params::log_level,
    $log_filter    = $::svmp::server::params::log_filter,

    # array of TURN server hashes to use
    # must have the url field
    # username and password are optional
    # example: [ { # STUN without credential
    #              'url' => 'stun:a.public.stunserver.com:3478',
    #            },
    #            { # STUN with credential
    #               'url' => 'stun:my.stunserver.com:3478',
    #               'password' => 'asdf1234'
    #            },
    #            { # TURN
    #              'url' => 'turn:my.turnserver.com:3478',
    #              'username' => 'bob', 'password' => 's3cr3t'
    #            },
    #          ]
    $ice_servers,

    $manage_user   = true,
    $manage_group  = true,
    $user          = $::svmp::server::params::user,
    $group         = $::svmp::server::params::group,
    $home_dir      = $::svmp::server::params::home_dir,
    $conf_dir      = $::svmp::server::params::conf_dir,
    $conf_file     = $::svmp::server::params::conf_file,
    $conf_template = $::svmp::server::params::conf_template,
    $service_name  = $::svmp::server::params::service_name,
    $init_template = $::svmp::server::params::init_template,

    $version       = $::svmp::server::params::version,

    $npm_name      = $::svmp::server::params::npm_name,

    $service_enable = true,
    $service_ensure = 'running',

) inherits svmp::server::params {
    validate_bool($enable_ssl)
    validate_bool($service_enable)

    # Input validation

    # check that the required overseeer options are set

    if $enable_ssl {
        # ensure SSL key params aren't empty
    }

    anchor { 'svmp::server::begin': }
    anchor { 'svmp::server::end': }

    include svmp::server::install
    include svmp::server::config
    include svmp::server::service

    Anchor['svmp::server::begin'] ->
        Class['svmp::server::install'] ->
        Class['svmp::server::config'] ->
        Class['svmp::server::service'] ->
    Anchor['svmp::server::end']

}
