# == Class: svmp-server
#
# Full description of class proxy here.
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
# Copyright 2013 Your name here, unless otherwise noted.
#

class svmp-server(
  $server_port   = 8002,
  $use_ssl       = false,
  $vm_port       = 8001,

  $ice_servers,

  # User authentication options
  $use_pam_auth  = false,
  $pam_service   = 'svmp',

  # Openstack options
  $cloud_auth_url,
  $cloud_username,
  $cloud_password,
  $cloud_tenant_id,
  $cloud_tenant_name,

  $manage_repos  = false,

  # Node.js / NPM options
  $npm_proxy     = '',

  # Mongodb options
  $install_db    = true,
  $db_host       = 'localhost',
  $db_name       = 'svmp_server_db',

  $svmp_user     = 'svmp',
  $svmp_group    = 'svmp',
  $version       = 'svmp-1.1',
  $install_dir   = '/opt/svmp-server',
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
    source   => 'https://github.com/SVMP/svmp-server.git',
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
  }

  class { 'nodejs':
    proxy => $npm_proxy,
  } ->

  package { 
    'protobuf':         provider => 'npm';
    'q':                provider => 'npm';
    'uid2':             provider => 'npm';
    'mongoose':         provider => 'npm';
    'commander':        provider => 'npm';
    'colors':           provider => 'npm';
    'pkgcloud':         provider => 'npm';
    'authenticate-pam': provider => 'npm';
    'winston':          provider => 'npm';
  } <- Package['libpamdev']


  if $install_db {
    class { 'mongodb':
      enable_10gen => true,
      smallfiles   => true,
    }
  }

}
