import sys, os

if len(sys.argv) < 2:
    print("Uso: wlst.sh extend_em.py /caminho/extend_em.properties")
    exit(1)

propFile = sys.argv[1]
loadProperties(propFile)

# Variáveis vêm do .properties
domainHome   = DOMAIN_HOME
jrfTemplate  = JRF_TEMPLATE
fmwTemplate  = FMW_SCHEMA_TEMPLATE
emTemplate   = EM_TEMPLATE

dbHost       = DB_HOST
dbPort       = DB_PORT
dbService    = DB_SERVICE
rcuPrefix    = RCU_PREFIX
schemaPass   = SCHEMA_PASSWORD

dbUrl = "jdbc:oracle:thin:@//%s:%s/%s" % (dbHost, dbPort, dbService)
stbUser = "%s_STB" % (rcuPrefix)

print("==> Domain: %s" % domainHome)
print("==> DB URL: %s" % dbUrl)
print("==> STB User: %s" % stbUser)

def set_ds_password(jdbcResourceName, passwordPlain):
    # seta PasswordEncrypted no datasource informado
    cd('/JDBCSystemResource/%s/JdbcResource/%s/JDBCDriverParams/NO_NAME_0' % (jdbcResourceName, jdbcResourceName))
    set('PasswordEncrypted', encrypt(passwordPlain, domainHome))

readDomain(domainHome)

# 1) Aplicar templates (ordem importa) - precisa atualizar para logica selectTemplate
addTemplate(jrfTemplate)
addTemplate(fmwTemplate)
addTemplate(emTemplate)

# 2) Configurar LocalSvcTblDataSource (aparece após aplicar templates)
# URL + driver
cd('/JDBCSystemResource/LocalSvcTblDataSource/JdbcResource/LocalSvcTblDataSource/JDBCDriverParams/NO_NAME_0')
set('URL', dbUrl)
set('DriverName', 'oracle.jdbc.OracleDriver')

# user
cd('Properties/NO_NAME_0/Property/user')
set('Value', stbUser)

# password (STB)
set_ds_password('LocalSvcTblDataSource', schemaPass)

# 3) Popular schemas/datasources do FMW a partir do STB
# (usa o LocalSvcTblDataSource)
getDatabaseDefaults()

# 4) Garantir senha em todos os Component Schemas criados pelo FMW
# (evita ficar com PasswordEncrypted vazio em alguns casos)
cd('/')
jdbcList = ls('JDBCSystemResource', returnMap='true')
for ds in jdbcList:
    # pula o LocalSvcTblDataSource (já setamos acima)
    if ds == 'LocalSvcTblDataSource':
        continue
    try:
        cd('/JDBCSystemResource/%s/JdbcResource/%s/JDBCDriverParams/NO_NAME_0/Properties/NO_NAME_0/Property/user' % (ds, ds))
        usr = get('Value')
        # só altera se for schema do seu prefixo (DEV01_*)
        if usr and usr.startswith(rcuPrefix + "_"):
            cd('/JDBCSystemResource/%s/JdbcResource/%s/JDBCDriverParams/NO_NAME_0' % (ds, ds))
            set('PasswordEncrypted', encrypt(schemaPass, domainHome))
    except:
        pass

updateDomain()
closeDomain()
exit()