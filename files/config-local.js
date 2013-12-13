module.exports = {
       settings: {
                  db: 'mongodb://localhost/svmp_proxy_db',
                  port: 8001,
                  tls_proxy: false,
                  vm_port: 5000,
                  test_db: 'mongodb://localhost/proxy_testing_db',
                  openstack: {"authUrl": "http://", 
                              "username": "test", 
                              "password": "test",
                              "tenantId": "eee",
                              "tenantName": "hello" },
                  pam: {service: '', remotehost: ''}
                 },
           // Video Information sent from Proxy to Client
           webrtc: {
                    ice: { iceServer: [{url: 'stun1234'}]},
                    video: { audio: true, video: { mandatory: {}, optional: []}},
                    pc: {optional: [{DtlsSrtpKeyAgreement: true}]}
                   }
};
