# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#

$ice_servers = [ {
                   url => 'stun:127.0.0.1:3478',
                 },
                 {
                   url => 'turn:127.0.0.1:3478',
                   username => 'user',
                   password => 'credential',
                 },
               ]

class { 'svmp::server':
  overseer_url  => 'http://localhost/',
  overseer_cert => '/path/to/overseer-cert.pem',
  auth_token    => 'asdfasdfasdfasdfa.zxcvzxcvzvzxcvzxcv.qwerqwerqwerqwerqwer',

  version  => 'master', # the svmp-2.0.0 tag doesn't exist yet

  ice_servers   => $ice_servers,
}

class { 'svmp::overseer':
  console_session_secret => 'wqeroiuyafglkjadoiauylaskjdhasdf',
  proxy_host => $::fqdn,
  cloud_platform => 'openstack',
  ice_servers => $ice_servers,
  cloud_vm_images => { 'phone' => 'asdf-zxcv-qwer', 'tablet' => '1234-5678-90' },
  version => 'master', # the svmp-2.0.0 tag doesn't exist yet
}
