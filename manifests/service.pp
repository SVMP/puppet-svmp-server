class svmp_server::service inherits svmp_server {
    package { 'forever':
        provider => 'npm',
    }

   service { $service_name:
       enable   => true,
       ensure   => running,
#       require  => [ File['/etc/init.d/svmp_server'], Package['forever'], ],
   }

}
