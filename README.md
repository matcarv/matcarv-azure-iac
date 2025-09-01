# matcarv-azure-iac
MatCarv - Azure Infrastructure as Code

## Arquitetura

Esta infraestrutura cria uma solução resiliente no Azure com módulos independentes:

### Rede (VNET)
- **VNet**: 171.13.0.0/22
- **Subnets Públicas**: 
  - subnet-public-1: 171.13.0.0/24
  - subnet-public-2: 171.13.1.0/24
- **Subnets Privadas**:
  - subnet-private-1: 171.13.2.0/24 (Bancos de dados)
  - subnet-private-2: 171.13.3.0/24 (AKS)
- **NAT Gateway**: Conectividade de saída para subnets privadas

### Bancos de Dados
- **SQL Server**: Instância Basic com Private Endpoint, TDE habilitado
- **PostgreSQL**: Flexible Server B1ms com criptografia automática
- **Backup**: 7 dias de retenção para ambos
- **Conectividade**: Apenas via rede privada com DNS privado

### Kubernetes (AKS)
- **Cluster**: 2 nodes Standard_B2s (4GB RAM) na subnet privada
- **Segurança**: RBAC, Network Policy, Microsoft Defender
- **Monitoramento**: Log Analytics com 30 dias de retenção
- **Secrets**: Key Vault integration habilitado

### Container Registry (ACR)
- **Registries**: Array configurável (default: acrmatcarv, acrmatcarvdev)
- **SKU**: Basic (econômico)
- **Segurança**: Acesso público desabilitado, integração nativa com AKS

### Remote State
- **Storage Account**: Centralizado para todos os módulos
- **Organização**: Subpastas por módulo via key
- **Segurança**: Criptografado e com backup automático

## Estrutura Modular

```
matcarv-azure-iac/
├── REMOTE-STATE/           # Módulo Remote State
│   ├── remote-state.tf     # Storage Account + Container
│   ├── variables.tf        # Variáveis com defaults
│   ├── outputs.tf          # Informações do backend
│   └── README.md           # Documentação específica
├── VNET/                   # Módulo de rede
│   ├── vnet.tf             # Virtual Network
│   ├── subnets.tf          # Subnets públicas e privadas
│   ├── nat-gateway.tf      # NAT Gateway e IP público
│   ├── variables.tf        # Variáveis com defaults
│   └── outputs.tf          # Outputs da rede
├── SQL-SERVER/             # Módulo SQL Server
│   ├── sql-server.tf       # SQL Server
│   ├── sql-database.tf     # SQL Database
│   ├── private-endpoint.tf # Private Endpoint
│   ├── private-dns.tf      # DNS privado
│   ├── variables.tf        # Variáveis com defaults
│   └── outputs.tf          # Outputs do SQL
├── POSTGRESQL/             # Módulo PostgreSQL
│   ├── postgresql-server.tf    # PostgreSQL Flexible Server
│   ├── postgresql-database.tf  # Database
│   ├── private-endpoint.tf     # Private Endpoint
│   ├── private-dns.tf          # DNS privado
│   ├── variables.tf            # Variáveis com defaults
│   └── outputs.tf              # Outputs do PostgreSQL
├── AKS/                    # Módulo Kubernetes
│   ├── aks-cluster.tf      # Cluster AKS
│   ├── log-analytics.tf    # Log Analytics Workspace
│   ├── variables.tf        # Variáveis com defaults
│   └── outputs.tf          # Outputs do AKS
└── ACR/                    # Módulo Container Registry
    ├── acr.tf              # Azure Container Registry (array)
    ├── variables.tf        # Variáveis com defaults
    └── outputs.tf          # Outputs do ACR
```

## Deploy com Remote State

### 1. Configurar Remote State (PRIMEIRO)
```bash
cd REMOTE-STATE
terraform init
terraform plan
terraform apply
```

### 2. Deploy dos Módulos (em ordem)

**Rede (VNET):**
```bash
cd VNET
terraform init  # Migra para remote state
terraform plan
terraform apply
```

**SQL Server:**
```bash
cd SQL-SERVER
terraform init  # Migra para remote state
terraform plan
terraform apply
```

**PostgreSQL:**
```bash
cd POSTGRESQL
terraform init  # Migra para remote state
terraform plan
terraform apply
```

**AKS:**
```bash
cd AKS
terraform init  # Migra para remote state
terraform plan
terraform apply
```

**ACR:**
```bash
cd ACR
terraform init  # Migra para remote state
terraform plan
terraform apply
```

## Remote State Structure

```
Storage Account: tfstatematcarv
Container: tfstate/
├── vnet/terraform.tfstate
├── sql-server/terraform.tfstate
├── postgresql/terraform.tfstate
├── aks/terraform.tfstate
└── acr/terraform.tfstate
```

## Configuração

### Variáveis Principais
Cada módulo tem suas próprias variáveis com valores default:

**VNET:**
- `vnet_cidr` = "171.13.0.0/22"
- `location` = "East US"
- `service_endpoints` = ["Microsoft.Sql"]

**SQL-SERVER:**
- `sql_admin_login` = "sqladmin"
- `sql_admin_password` = "P@ssw0rd123!" (sensitive)

**POSTGRESQL:**
- `postgres_admin_login` = "pgladmin"
- `postgres_admin_password` = "P@ssw0rd123!" (sensitive)

**AKS:**
- `node_count` = 2
- `vm_size` = "Standard_B2s"
- `kubernetes_version` = "1.30.14"

**ACR:**
- `acr_names` = ["acrmatcarv", "acrmatcarvdev"]
- `acr_sku` = "Basic"

### Customização
Para customizar, crie um arquivo `terraform.tfvars` em cada módulo:

```hcl
# VNET/terraform.tfvars
location = "West Europe"
vnet_cidr = "192.168.0.0/22"

# ACR/terraform.tfvars
acr_names = ["acrprod", "acrdev", "acrstaging"]
acr_sku = "Standard"
```

## Pós-Deploy

### Conectar ao AKS
```bash
# Obter credenciais do cluster
az aks get-credentials --resource-group rg-matcarv --name aks-matcarv

# Listar namespaces
kubectl get namespaces
```

### Usar ACR com AKS
```bash
# Login no ACR
az acr login --name acrmatcarv

# Push de imagem
docker tag myapp:latest acrmatcarv.azurecr.io/myapp:latest
docker push acrmatcarv.azurecr.io/myapp:latest

# Deploy no AKS
kubectl create deployment myapp --image=acrmatcarv.azurecr.io/myapp:latest
```

### Conectar aos Bancos de Dados
```bash
# Via kubectl port-forward (para testes)
kubectl run sqlcmd --image=mcr.microsoft.com/mssql-tools --restart=Never -it --rm -- /bin/bash
kubectl run psql --image=postgres:14 --restart=Never -it --rm -- /bin/bash
```

## Segurança

### Recursos com criptografia habilitada:
- **SQL Server**: TDE + TLS 1.2 mínimo + Private Endpoint
- **PostgreSQL**: Criptografia automática + SSL/TLS + Private Endpoint
- **AKS**: RBAC, Network Policy, Microsoft Defender, Key Vault integration
- **ACR**: Acesso público desabilitado, integração segura com AKS
- **Rede**: Private Endpoints, DNS privado, NAT Gateway para saída segura
- **Remote State**: Criptografado em repouso, TLS 1.2, acesso privado

### Configurações de segurança:
- Acesso público desabilitado em todos os serviços
- Comunicação apenas via rede privada
- Monitoramento com Log Analytics
- Tags para governança e compliance
- Managed identities para autenticação
- State locking para evitar conflitos

## Conectividade

Todos os serviços estão configurados com Private Endpoints e DNS privado, acessíveis apenas pelos recursos na VNet. O NAT Gateway permite que recursos nas subnets privadas tenham acesso de saída à internet para atualizações e downloads, mantendo a segurança contra acessos externos.

## Custos Estimados

**Região East US (mensal):**
- **VNET + NAT Gateway**: ~$45
- **SQL Server Basic**: ~$5
- **PostgreSQL B1ms**: ~$15
- **AKS (2x Standard_B2s)**: ~$60
- **ACR Basic (2x)**: ~$10
- **Log Analytics**: ~$5
- **Remote State Storage**: ~$2

**Total estimado**: ~$142/mês

Para estimativas detalhadas, consulte a [Calculadora de Preços do Azure](https://azure.microsoft.com/pricing/calculator/).

## Módulos Independentes

Cada módulo pode ser usado independentemente, permitindo:
- **Deploy seletivo** de componentes
- **Reutilização** em outros projetos
- **Manutenção** isolada por serviço
- **Customização** específica por ambiente
- **Colaboração em equipe** com Remote State
- **Versionamento** e backup automático do state
