# Kubernetes - Esquema Zabbix Server, PostgresDB, Zabbix Frontend e servidor Grafana
Implementação de cluster Kubernetes para orquestração de Zabbix Server, Zabbix Frontend, Grafana e banco de dados Postgres para fins de aprendizagem, utilizando devbox para gestão de dependências desacopladas do sistema e KIND para criação de cluster local.

---

## Tecnologias

    - Kubernetes
    - KIND
    - Golang
    - Minikube 
    - Zabbix 
    - Grafana
    - Postgresql
---

### Dependências

Primeiro de tudo é necessário instalar o devbox em seu sistema. 
Visite o [repositório do devbox](https://github.com/jetify-com/devbox) para ler as instruções de como instalá-lo em sua máquina. 

Em seguida você executar o comando ```devbox shell``` dentro do diretório do raíz do repositório para o devbox instalar todas dependências necessárias do projeto 
**OBS**: você pode modificar as dependências de acordo com seu desejo editando o arquivo *devbox.json* (leia a documentação do [devbox](https://www.jetify.com/docs/devbox/))

---

### Criando Cluster local Kubernetes com Kind

- Dê permissões de execução para o script kmanagement.sh  
    ``chmod 771 kmanagement.sh`` 
- Execute o script e prossiga de acordo com as configurações necessárias 

!(./images/default.png)
