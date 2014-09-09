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
    package { 'forever':
        provider => 'npm',
    }

    service { $::svmp::overseer::service_name:
        ensure  => $::svmp::overseer::service_ensure,
        enable  => $::svmp::overseer::service_enable,
        require => [
            Package['npm'],
            File["/etc/init.d/${::svmp::overseer::service_name}"],
        ],
    }
}
