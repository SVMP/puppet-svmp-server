# == Class: svmp::overseer::service
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
class svmp::overseer::service inherits svmp::overseer {
    package { 'python-setuptools': } ->
    package { 'python-pip': } ->

    class { 'supervisord':
        #install_pip => true,
    }

    case $::osfamily {
        'Debian': {
            $install_path = '/usr/local/bin'
        }
        'RedHat': {
            $install_path = '/usr/bin'
        }
        default: {
            $install_path = '/usr/local/bin'
        }
    }

    supervisord::program { $::svmp::overseer::service_name:
        command         => "${install_path}/svmp-overseer",
        user            => $::svmp::overseer::user,
        priority        => '100',
        environment     => {
            'HOME'     => $::svmp::overseer::home_dir,
            'PATH'     => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
            'NODE_ENV' => 'production',
            'config'   => "${::svmp::overseer::conf_dir}/${::svmp::overseer::conf_file}"
        },
        redirect_stderr => true,
        stdout_logfile  => 'svmp-overseer.out'
    }
}
