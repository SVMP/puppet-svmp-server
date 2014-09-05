# == Class: svmp::overseer::config
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
class svmp::overseer::config inherits svmp::overseer {
    file { "${::svmp::overseer::conf_dir}/${::svmp::overseer::conf_file}":
        ensure  => file,
        owner   => $::svmp::overseer::user,
        group   => $::svmp::overseer::group,
        mode    => '0640',
        content => template($::svmp::overseer::conf_template),
        require => File[$::svmp::overseer::conf_dir],
#        notify  => Service[$::svmp::overseer::service_name],
    }

    $daemon_name = 'svmp-overseer'

    file { "/etc/init.d/${::svmp::overseer::service_name}":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
        content => template($::svmp::overseer::init_template),
#        notify  => Service[$::svmp::overseer::service_name],
    }

}
