# == Class: svmp::overseer
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
class svmp::overseer (
    $server_port = $::svmp::overseer::params::server_port,
    $server_url  = $::svmp::overseer::params::server_url,

    # Logging
    $log_dir       = $::svmp::overseer::params::log_dir,
    $log_file      = $::svmp::overseer::params::log_file,
    $log_level     = $::svmp::overseer::params::log_level,

    # Database options
    $db_host      = $::svmp::overseer::params::db_host,
    $db_name      = $::svmp::overseer::params::db_name,

    # SSL options
    $enable_ssl   = false,
    $ssl_cert     = undef,
    $ssl_key      = undef,
    $ssl_key_pass = undef,
    $ssl_ca       = undef,

    # User authentication options
    $authentication_type  = $::svmp::overseer::params::authentication_type,
    $max_session_length   = $::svmp::overseer::params::max_session_length,
    $jwt_signing_alg      = $::svmp::overseer::params::jwt_signing_alg,
    $behind_reverse_proxy = $::svmp::overseer::params::behind_reverse_proxy,
    $pam_service          = $::svmp::overseer::params::pam_service,

    # svmp-server settings
    $proxy_host,
    $proxy_port = $::svmp::overseer::params::proxy_port,

    # VM settings
    $vm_port     = $::svmp::overseer::params::vm_port,
    $vm_idle_ttl = $::svmp::overseer::params::vm_idle_ttl,

    # Cloud settings
    $cloud_platform,

    $openstack_auth_url    = undef,
    $openstack_user        = undef,
    $openstack_password    = undef,
    $openstack_tenant_id   = undef,
    $openstack_tenant_name = undef,
    $openstack_region      = undef,

    $aws_access_key        = undef,
    $aws_secret_key        = undef,
    $aws_region            = undef,
    $aws_availability_zone = undef,

    $cloud_vm_images = undef,
    $cloud_vm_flavor = undef,
    $cloud_master_data_volume_id = undef,
    $cloud_master_data_volume_size = undef,
    $cloud_use_floating_ips = undef,
    $cloud_floating_ip_pool = undef,

    # WebRTC settings

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
    $user          = $::svmp::overseer::params::user,
    $group         = $::svmp::overseer::params::group,
    $home_dir      = $::svmp::overseer::params::home_dir,
    $conf_dir      = $::svmp::overseer::params::conf_dir,
    $conf_file     = $::svmp::overseer::params::conf_file,
    $conf_template = $::svmp::overseer::params::conf_template,
    $service_name  = $::svmp::overseer::params::service_name,
    $init_template = $::svmp::overseer::params::init_template,

    $version       = $::svmp::overseer::params::version,

    $npm_name      = $::svmp::overseer::params::npm_name,

) inherits svmp::overseer::params {

    anchor { 'svmp::overseer::begin': }
    anchor { 'svmp::overseer::end': }

    include svmp::overseer::install
    include svmp::overseer::config
    include svmp::overseer::service

    Anchor['svmp::overseer::begin'] ->
        Class['svmp::overseer::install'] ->
        Class['svmp::overseer::config'] ->
        Class['svmp::overseer::service'] ->
    Anchor['svmp::overseer::end']

}
