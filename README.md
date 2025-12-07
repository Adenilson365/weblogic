### Tem por Objetivo doumentar a Jornada de Instalar o application server Weblogic

### Preparando ambiente

- [sdkMan](https://sdkman.io/install/) - Permite instalar versões java de forma mais simplificada
- Instalação sem interface
  > Apartir da versão 12c não aceita flag -mode=console, usar modo silent

[Criar arquivo Silent](https://docs.oracle.com/middleware/1212/core/OUIRF/response_file.htm#OUIRF391)

- comando de instalação:

```shell
java -jar fmw_12.2.1.4.0_infrastructure.jar -silent -responseFile /u01/software/weblogic/silent.xml -invPtrLoc /u01/software/weblogic/oraInst.loc
```

## Criar Domínio usando wlst

[Documentação](https://docs.oracle.com/middleware/1221/wls/WLSTG/domains.htm#CHDGAJIB)

> config.sh -mode=console não funcionou

- Scripts ficam na $MW_HOME/oracle_commom/common/bin
- Usar o wlst.sh
- Vai abrir em modo offline, passe os comandos

> template base: $MW_HOME/wlserver/common/templates/wls/wls.jar

- Use os comandos do createDomain.py

- Diretório do domínio: $MW_HOME/user_projects/domains/basicWLSDomain
- Nessa Pasta há os script de start para subir o admin

### Scripts

- **Iniciar manualmente servidor**
- Ficam dentro da pasta do domínio em /bin
- script: starManagerServers.sh <nomeServidor>
- Ser
