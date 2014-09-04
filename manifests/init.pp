# == Class: svmp_server
#
# Installs and configures the gateway server of the Secure Virtual Mobile Platform.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { proxy:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# David Keppler <dkeppler@mitre.org>
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

class svmp_server(
    $server_port   = $::svmp_server::params::port,

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
    $cert_user_auth       = $::svmp_server::params::cert_user_auth,
    $behind_reverse_proxy = $::svmp_server::params::behind_reverse_proxy,

    $log_dir       = $::svmp_server::params::log_dir,
    $log_file      = $::svmp_server::params::log_file,
    $log_level     = $::svmp_server::params::log_level,
    $log_filter    = $::svmp_server::params::log_filter,

    # array of TURN server hashes to use
    # must have the url field
    # username and password are optional
    # example: [ {'url' => 'turn:my.turnserver.com:3478', 'username' => 'bob', 'password' => 's3cr3t' },
    #            {'url' => 'stun:my.stunserver.com:3478', 'password' => 'asdf1234' },
    #          ]
    $ice_servers,

    $manage_user   = true,
    $manage_group  = true,
    $user          = $::svmp_server::params::user,
    $group         = $::svmp_server::params::group,
    $conf_dir      = $::svmp_server::params::conf_dir,
    $conf_file     = $::svmp_server::params::conf_file,
    $conf_template = $::svmp_server::params::conf_template,
    $service_name  = $::svmp_server::params::service_name,

    $version       = $::svmp_server::params::version,

    $npm_name      = $::svmp_server::params::npm_name,

    $service_enable = true,
    $service_ensure = 'running',

) inherits ::svmp_server::params {
    validate_bool($enable_ssl)
    validate_bool($service_enable)

    # Input validation

    # check that the required overseeer options are set

    if $enable_ssl {
        # ensure SSL key params aren't empty
    }

    anchor { 'svmp_server::begin': }
    anchor { 'svmp_server::end': }

    include svmp_server::install
    include svmp_server::config
    include svmp_server::service

    Anchor['svmp_server::begin'] ->
        Class['svmp_server::install'] ->
        Class['svmp_server::config'] ->
        Class['svmp_server::service'] ->
    Anchor['svmp_server::end']

}
