# == Class: svmp-server
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
# Copyright (c) 2012-2013, The MITRE Corporation, All Rights Reserved.
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

class svmp-server(
  # Mongodb options
  $install_db    = true,
  $db_host       = 'localhost',
  $db_name       = 'svmp_server_db',

  $log_file      = '/var/log/svmp-server.log',

  $server_port   = 8002,
  $vm_port       = 8001,

  $use_ssl       = false,
  $ssl_cert_path = '',
  $ssl_key_path  = '',

  # User authentication options
  $session_max_length = 21600,
  $session_token_ttl  = 300,
  $session_check_interval = 60,
  $use_pam       = false,
  $pam_service   = 'svmp',

  # Web console options
  $enable_web_console = false,
  $enable_email  = false,
  $smtp_server   = '',
  $admin_contact_address = '',

  # array of TURN servers to use
  $ice_servers,

  # Openstack options
  $cloud_auth_url,
  $cloud_username,
  $cloud_password,
  $cloud_tenant_id,
  $cloud_tenant_name,

  $manage_repos  = false,

  # Node.js / NPM options
  $npm_proxy     = '',

  $svmp_user     = 'svmp',
  $svmp_group    = 'svmp',
  $version       = 'svmp-1.1',
  $install_dir   = '/opt/svmp-server',

  $source_repository = 'https://github.com/SVMP/svmp-server.git',
) {

  # Package prereqs
  case $operatingsystem {
    'RedHat', 'CentOS': {
      if $manage_repos == true {
        include epel
      }
      $pam_devel_package_name = 'pam-devel'
    }
    
    'Debian', 'Ubuntu': {
      $pam_devel_package_name = 'libpam-dev'
    }
  }

  package { 'libpamdev':
    name => $pam_devel_package_name,
  }

  package { 'git': }

  # Set up the SVMP group and user
  group { $svmp_group:
    ensure => present,
    system => true,
  }

  user { $svmp_user:
    ensure => present,
    system => true,
    gid    => $svmp_group,
    home   => $install_dir,
    require => Group[$svmp_group],
  }

  file { $install_dir:
    ensure => directory,
    owner  => 'svmp',
    group  => 'svmp',
    mode   => '770',
    require => [ User[$svmp_user], Group[$svmp_group], ],
  } 

  vcsrepo { $install_dir:
    ensure   => latest,
    user     => $svmp_user,
    provider => git,
    source   => $source_repository,
    revision => $version,
    require  => [ Package['git'], File[$install_dir] ],
  }

  file { 'config-local.js':
    name    => "${install_dir}/config/config-local.js",
    ensure  => file,
    owner   => $svmp_user,
    group   => $svmp_group,
    mode    => '660',
    content => template('svmp-server/config-local.js.erb'),
    require => Vcsrepo[$install_dir],
    notify  => Service['svmp-server'],
  }

  class { 'nodejs':
    proxy => $npm_proxy,
  } ->

  exec { "npm_install_svmp_server":
      command => "npm install",
      user => $svmp_user,
      cwd => $install_dir,
      environment => "HOME=/opt/svmp-server",
      path => $::path,
      require => [ Vcsrepo[$install_dir], User[$svmp_user], Package['libpamdev'] ],
  }

  package { 'forever':
    provider => 'npm',
  }

  file { '/etc/init.d/svmp-server':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '755',
    content => template('svmp-server/svmp-init.erb'),
  }

  service { 'svmp-server':
    enable   => true,
    ensure   => running,
    require  => [ File['/etc/init.d/svmp-server'], Package['forever'], ],
  }

  if $install_db {
    class { 'mongodb':
      enable_10gen => true,
      smallfiles   => true,
    }
  }

}
