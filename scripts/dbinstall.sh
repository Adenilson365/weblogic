#### Instala oracle database21c express edition ####
#https://www.oracle.com/br/database/technologies/xe-downloads.html?REDbTNjXWeq5z=9RyJN
#https://docs.oracle.com/en/database/oracle/oracle-database/21/xeinl/installing-oracle-database-free.html#GUID-46EA860A-AAC4-453F-8EEE-42CC55A4FAD5

curl -o oracle-database-preinstall-21c-1.0-1.el8.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/getPackage/oracle-database-preinstall-21c-1.0-1.el8.x86_64.rpm
dnf -y localinstall oracle-database-preinstall-21c-1.0-1.el8.x86_64.rpm
dnf -y localinstall oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm

# configure oracle DB password - weblogic
/etc/init.d/oracle-xe-21c configure 

export PATH=$PATH:/opt/oracle/product/21c/dbhomeXE/bin/

export ORACLE_SID=XE
export ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE