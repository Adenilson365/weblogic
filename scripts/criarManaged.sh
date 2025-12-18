#!/bin/bash
export ORACLE_HOME=/u01/app/oracle/product/middleware
$ORACLE_HOME/oracle_common/common/bin/wlst.sh 

readDomain('/u01/app/oracle/domains/basicWLSDomain')
cd('/')
create('soa1','Server')
cd('/Servers/soa1')
set('ListenAddress','')
set('ListenPort', 7003)
updateDomain()
closeDomain()
exit()


# Criar o boot.properties para o servidor soa1
mkdir -p /u01/app/oracle/domains/basicWLSDomain/servers/soa1/security
echo "username=weblogic" > /u01/app/oracle/domains/basicWLSDomain/servers/soa1/security/boot.properties
echo "password=welcome1" >> /u01/app/oracle/domains/basicWLSDomain/servers/soa1/security/boot.properties

# Para subir via admin, precisa
