#!/bin/bash
asadmin start-domain

touch /usr/local/glassfish3/passkey
chmod 777 /usr/local/glassfish3/passkey
echo 'AS_ADMIN_PASSWORD=admin' > /usr/local/glassfish3/passkey

asadmin -u admin -W /usr/local/glassfish3/passkey -H localhost -p 4848 enable-secure-admin

#asadmin -u admin -W /usr/local/glassfish3/passkey add-resources \
#        /usr/local/glassfish3/glassfish/domains/domain1/config/resource.xml

asadmin restart-domain