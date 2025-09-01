# Nome do resource group
variable "resource_group_name" {
  description = "Nome do resource group"
  type        = string
  default     = "rg-matcarv"
}

# Localização dos recursos
variable "location" {
  description = "Localização do Azure"
  type        = string
  default     = "East US"
}

# ID da subnet para AKS
variable "aks_subnet_id" {
  description = "ID da subnet para AKS"
  type        = string
  default     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-matcarv/providers/Microsoft.Network/virtualNetworks/vnet-matcarv/subnets/subnet-private-2"
}

# Versão do Kubernetes
variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.30.14"
}

# Número de nodes
variable "node_count" {
  description = "Número de nodes no cluster"
  type        = number
  default     = 2
}

# Tamanho da VM
variable "vm_size" {
  description = "Tamanho da VM para os nodes"
  type        = string
  default     = "Standard_B2s"
}

# CIDR para serviços do Kubernetes
variable "service_cidr" {
  description = "CIDR para serviços do Kubernetes"
  type        = string
  default     = "192.168.0.0/22"
}

# IP do serviço DNS
variable "dns_service_ip" {
  description = "IP do serviço DNS do Kubernetes"
  type        = string
  default     = "192.168.1.10"
}

# Retenção de logs em dias
variable "log_retention_days" {
  description = "Dias de retenção dos logs"
  type        = number
  default     = 30
}

# Tags comuns para todos os recursos
locals {
  common_tags = {
    Environment = "Production"
    Project     = "MatCarv"
    CreatedBy   = "Terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
    Owner       = "DevOps Team"
  }
}
