#/bin/bash

# Criar usuário:
groupadd oinstall
groupadd dba

# Adicionar usuário ao sistema:
useradd -g oinstall -G dba -d /u01/app/oracle -m -s /bin/bash oracle

# Criar diretórios necessários:
mkdir -p /u01/app/oracle/{product,config,domains,logs,scripts}
mkdir -p /u01/software/{jdk,weblogic}

#### Diretórios ####
#/u01/app/oracle/product para -> binários do WebLogic e JDK instalados
#/u01/app/oracle/config para -> configs gerais
#/u01/app/oracle/domains para -> domínios do WebLogic (base_domain, etc.)
#/u01/app/oracle/logs para -> logs consolidados (scripts, rotações, etc.)
#/u01/app/oracle/scripts para -> scripts de start/stop, backup, etc.
#/u01/software/jdk e /u01/software/weblogic para -> instaladores (.jar, .rpm, etc.)


#Ajustando permissões dos diretórios:
chown -R oracle:oinstall /u01
chmod -R 775 /u01

# Criar a swap caso esteja em cloud
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
sudo chmod 600 /swapfile
sudo chown root:root /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile   none    swap    sw    0   0' | sudo tee -a /etc/fstab

#/u01/software/jdk e /u01/software/weblogic vai ficar os arquivos base de instalação
# mova o jdk para /u01/app/oracle/product
mv /u01/software/jdk/jdk-8u202-linux-x64.tar.gz /u01/app/oracle/product
cd /u01/app/oracle/product
tar -xvzf jdk-8u202-linux-x64.tar.gz
rm -f jdk-8u202-linux-x64.tar.gz

#exportar variáveis de ambiente do JDK
export JAVA_HOME=/u01/app/oracle/product/jdk1.8.0_202
export PATH=$JAVA_HOME/bin:$PATH

# valide se o java está funcionando
java -version

# Dentro ra pasta /u01/software/weblogic, deve estar:
# fmw_12.2.1.4.0_wls.jar
# silent.xml
# oraInst.loc
# createDomain.py

# Instalar o wevblogic
cd  /u01/software/weblogic
java -jar fmw_12.2.1.4.0_infrastructure.jar -silent -responseFile /u01/software/weblogic/silent.xml -invPtrLoc /u01/software/weblogic/oraInst.loc


#Apos instalação, validar pasta middleware
ls -l /u01/app/oracle/product/middleware

#link simbolico para JDK
ln -sfn /u01/app/oracle/product/jdk1.8.0_471/  java
# Criar domínio básico do WebLogic
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/middleware # onde esta o WebLogic, onde foi isntalado no passo anterior
export JAVA_HOME=/u01/app/oracle/product/jdk1.8.0_202  # onde esta a JDK 
export PATH=$JAVA_HOME/bin:$ORACLE_HOME/oracle_common/common/bin:$PATH

# Criar o domínio básico
cd /u01/software/weblogic
$ORACLE_HOME/oracle_common/common/bin/wlst.sh \
  /u01/software/weblogic/createDomain.py

# Subir node manager e admin server
cd /u01/app/oracle/domains/basicWLSDomain/bin
nohup ./startNodeManager.sh > /u01/app/oracle/logs/nodemanager.log &
nohup ./startWebLogic.sh > /u01/app/oracle/logs/adminserver.log & 
tail -f /u01/app/oracle/logs/adminserver.log



# Exportar Opatch
export OPatch=/u01/app/oracle/product/middleware/OPatch/
export PATH=$OPatch:$PATH
# Validar opatch
opatch version




