# matcarv-azure-iac
MatCarv - Azure Infrastructure as Code

## Arquitetura

Esta infraestrutura cria uma solução resiliente no Azure com:

### Rede
- **VNet**: 171.13.0.0/22
- **Subnets Públicas**: 
  - subnet-public-1: 171.13.0.0/24
  - subnet-public-2: 171.13.1.0/24
- **Subnets Privadas**:
  - subnet-private-1: 171.13.2.0/24 (SQL Server)
  - subnet-private-2: 171.13.3.0/24 (AKS)
- **NAT Gateway**: Conectividade de saída para subnets privadas

### Serviços
- **SQL Server**: Instância econômica (Basic) com Private Endpoint na subnet privada
- **SQL Database**: 2GB Basic tier com criptografia TLS 1.2
- **AKS Cluster**: 2 nodes Standard_B2s (4GB RAM) na subnet privada com segurança avançada
- **Log Analytics**: Monitoramento e observabilidade
- **Conectividade**: SQL Server acessível apenas pelo AKS via rede privada

## Estrutura de Arquivos

- `main.tf` - Configuração do provider
- `resource-groups.tf` - Grupos de recursos
- `network.tf` - VNet, subnets e NAT Gateway
- `sqlserver.tf` - SQL Server + Database + Private Endpoint
- `aks.tf` - Cluster Kubernetes com segurança avançada
- `variables.tf` - Variáveis
- `outputs.tf` - Outputs
- `install-agic.ps1` - Script PowerShell para instalar AGIC
- `cost-estimate.html` - Página com estimativa de custos

## Deploy

```bash
# Login no Azure
az login

# Inicializar Terraform
terraform init

# Planejar deployment
terraform plan

# Aplicar mudanças
terraform apply
```

## Pós-Deploy

### Conectar ao AKS
```bash
# Obter credenciais do cluster
az aks get-credentials --resource-group rg-matcarv --name aks-matcarv

# Listar namespaces
kubectl get namespaces
```

### Instalar Application Gateway Ingress Controller
```powershell
# Executar script PowerShell
.\install-agic.ps1
```

### Conectar ao SQL Server
```bash
# Via kubectl port-forward (para testes)
kubectl run sqlcmd --image=mcr.microsoft.com/mssql-tools --restart=Never -it --rm -- /bin/bash
```

## Segurança

### Recursos com criptografia habilitada:
- **SQL Server**: TLS 1.2 mínimo, criptografia em trânsito e repouso
- **AKS**: RBAC, Network Policy, Microsoft Defender, Key Vault integration
- **Rede**: Private Endpoints, DNS privado, NAT Gateway para saída segura

### Configurações de segurança:
- Acesso público desabilitado em todos os serviços
- Comunicação apenas via rede privada
- Monitoramento com Log Analytics
- Tags para governança e compliance

## Conectividade

O SQL Server está configurado com Private Endpoint e DNS privado, acessível apenas pelos recursos na VNet. O NAT Gateway permite que recursos nas subnets privadas tenham acesso de saída à internet para atualizações e downloads, mantendo a segurança contra acessos externos.

## Custos

Consulte o arquivo `cost-estimate.html` para estimativa detalhada de custos mensais (~$127.50 USD/mês).
