# Crie o arquivo rcu-pass-file.txt com duas linhas contendo a senha do sys
# Exemplo:
# senhaforte
# senhaforte

./rcu -silent -createRepository -databaseType ORACLE \
  -connectString 192.168.200.201:1521/xepdb1 \
  -dbUser sys -dbRole sysdba \
  -schemaPrefix DEV02 \
  -useSamePasswordForAllSchemaUsers true \
  -selectDependentsForComponents true \
  -component STB -component OPSS -component MDS -component WLS \
  -f < ./pass-rcu-file.txt

### Quando tela congelar coloque a senha do sys