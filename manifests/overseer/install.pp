# == Class: svmp::overseer::install
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
class svmp::overseer::install inherits svmp::overseer {
    # Set up the SVMP group and user
    validate_bool($manage_group)
    if $manage_group {
        group { $::svmp::overseer::group:
            ensure => present,
            system => true,
        }
    }

    validate_bool($::svmp::overseer::manage_user)
    if $::svmp::overseer::manage_user {
        user { $::svmp::overseer::user:
            ensure      => present,
            gid         => $::svmp::overseer::group,
            home        => $::svmp::overseer::home_dir,
            system      => true,
        }
        file { $::svmp::overseer::home_dir:
            ensure  => directory,
            owner   => $::svmp::overseer::user,
            group   => $::svmp::overseer::group,
            mode    => '0750',
            require => [
                User[$::svmp::overseer::user],
                Group[$::svmp::overseer::group],
            ],
        }
    }

    package { 'bower':
        ensure   => present,
        provider => 'npm',
    } ->

    package { "${::svmp::overseer::npm_name}#${::svmp::overseer::version}":
    #      ensure   => $version,
      ensure   => present,
      provider => 'npm',
    }

    file { $::svmp::overseer::conf_dir:
        ensure  => directory,
        owner   => $::svmp::overseer::user,
        group   => $::svmp::overseer::group,
        mode    => '0750',
        require => [
            User[$::svmp::overseer::user],
            Group[$::svmp::overseer::group],
        ],
    }

    file { $::svmp::overseer::log_dir:
        ensure  => directory,
        owner   => $::svmp::overseer::user,
        group   => $::svmp::overseer::group,
        mode    => '0750',
        require => [
            User[$::svmp::overseer::user],
            Group[$::svmp::overseer::group],
        ],
    }

}
