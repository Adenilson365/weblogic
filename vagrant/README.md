###

#

### Config de ssh

- O vagrant file cria o usuário com a sua id_rsa.pub, para login sem precisar senha com: `ssh vagrant@192.168.56.30`
- No windows use exporte a variável de ambiente apontando pra sua id_rsa.pub `$env:PUBKEY_PATH="C:{path}.ssh/id_rsa.pub"`
- No linux não é necessário env.

### Config Mode bridge

- Linux: `VAGRANT_BRIDGE=enp3s0`
- windows: `VAGRANT_BRIDGE=enp3s0 vagrant reload --provision`
- Resposta: ` weblogic: Which interface should the network bridge to? 1`

### Config de ip fixo

- Weblogic: 192.168.200.200
- Database: 192.168.200.201
