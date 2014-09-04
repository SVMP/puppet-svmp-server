# == Class: svmp::overseer::params
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
class svmp::overseer::params {
    $server_port = 3000
    $server_url  = "https://${::fqdn}:${server_port}/"

    # Logging
    $log_dir       = '/var/log/svmp-overseer'
    $log_file      = 'svmp-overseer.log'
    $log_level     = 'info'

    # Database options
    $db_host      = $::fqdn
    $db_name      = 'svmp'

    # SSL options
    $enable_ssl   = false

    # User authentication options
    $authentication_type  = 'password'
    $max_session_length   = 21600
    $jwt_signing_alg      = 'RS512'
    $behind_reverse_proxy = false
    $pam_service          = 'svmp'

    # svmp-server settings
    $proxy_host = $::fqdn
    $proxy_port = 8080

    # VM settings
    $vm_port     = 8001
    $vm_idle_ttl = 3600

    $user          = 'svmp_overseer'
    $group         = 'svmp_overseer'
    $conf_dir      = '/etc/svmp-overseer'
    $conf_file     = 'config-local.yaml'
    $conf_template = 'svmp/overseer/config-local.yaml.erb'
    $service_name  = 'svmp-overseer'

    $version       = 'svmp-2.0.0'
    $npm_name      = 'git+https://github.com/SVMP/svmp-overseer'
}
