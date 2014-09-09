# == Class: svmp::server::install
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
class svmp::server::install inherits svmp::server {
    # Set up the SVMP group and user
    validate_bool($manage_group)
    if $manage_group {
        group { $::svmp::server::group:
            ensure => present,
            system => true,
        }
    }

    validate_bool($::svmp::server::manage_user)
    if $::svmp::server::manage_user {
        user { $::svmp::server::user:
            ensure      => present,
            gid         => $::svmp::server::group,
            home        => $::svmp::server::home_dir,
            system      => true,
        }
        file { $::svmp::server::home_dir:
            ensure  => directory,
            owner   => $::svmp::server::user,
            group   => $::svmp::server::group,
            mode    => '0750',
            require => [
                User[$::svmp::server::user],
                Group[$::svmp::server::group],
            ],
        }
    }

    package { "${::svmp::server::npm_name}#${::svmp::server::version}":
#      ensure   => $version,
      ensure   => present,
      provider => 'npm',
    }

    file { $::svmp::server::conf_dir:
        ensure  => directory,
        owner   => $::svmp::server::user,
        group   => $::svmp::server::group,
        mode    => '0750',
        require => [
            User[$::svmp::server::user],
            Group[$::svmp::server::group],
        ],
    }

    file { $::svmp::server::log_dir:
        ensure  => directory,
        owner   => $::svmp::server::user,
        group   => $::svmp::server::group,
        mode    => '0750',
        require => [
            User[$::svmp::server::user],
            Group[$::svmp::server::group],
        ],
    }

}
