# == Class: svmp::server::config
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
class svmp::server::config inherits svmp::server {
    file { "${::svmp::server::conf_dir}/${::svmp::server::conf_file}":
        ensure  => file,
        owner   => $::svmp::server::user,
        group   => $::svmp::server::group,
        mode    => '0640',
        content => template($::svmp::server::conf_template),
        require => File[$::svmp::server::conf_dir],
    }
}
