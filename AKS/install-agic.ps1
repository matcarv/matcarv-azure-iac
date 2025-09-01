# Script PowerShell para instalar Application Gateway Ingress Controller (AGIC)
# Autor: MatCarv DevOps Team
# Data: $(Get-Date -Format "yyyy-MM-dd")

param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "rg-matcarv",
    
    [Parameter(Mandatory=$false)]
    [string]$AksClusterName = "aks-matcarv",
    
    [Parameter(Mandatory=$false)]
    [string]$AppGatewayName = "appgw-matcarv",
    
    [Parameter(Mandatory=$false)]
    [string]$AppGatewaySubnetCidr = "171.13.4.0/24"
)

Write-Host "🚀 Iniciando instalação do Application Gateway Ingress Controller (AGIC)" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan

# Verificar se Azure CLI está instalado
Write-Host "📋 Verificando Azure CLI..." -ForegroundColor Yellow
try {
    $azVersion = az --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Azure CLI encontrado" -ForegroundColor Green
    } else {
        throw "Azure CLI não encontrado"
    }
} catch {
    Write-Host "❌ Azure CLI não está instalado. Instale primeiro: https://docs.microsoft.com/cli/azure/install-azure-cli" -ForegroundColor Red
    exit 1
}

# Verificar se kubectl está instalado
Write-Host "📋 Verificando kubectl..." -ForegroundColor Yellow
try {
    $kubectlVersion = kubectl version --client 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ kubectl encontrado" -ForegroundColor Green
    } else {
        throw "kubectl não encontrado"
    }
} catch {
    Write-Host "❌ kubectl não está instalado. Instale primeiro: https://kubernetes.io/docs/tasks/tools/" -ForegroundColor Red
    exit 1
}

# Verificar login no Azure
Write-Host "🔐 Verificando login no Azure..." -ForegroundColor Yellow
try {
    $account = az account show 2>$null | ConvertFrom-Json
    if ($account) {
        Write-Host "✅ Logado como: $($account.user.name)" -ForegroundColor Green
    } else {
        throw "Não logado no Azure"
    }
} catch {
    Write-Host "❌ Não está logado no Azure. Execute: az login" -ForegroundColor Red
    exit 1
}

# Obter credenciais do AKS
Write-Host "🔑 Obtendo credenciais do AKS..." -ForegroundColor Yellow
try {
    az aks get-credentials --resource-group $ResourceGroupName --name $AksClusterName --overwrite-existing
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Credenciais do AKS obtidas com sucesso" -ForegroundColor Green
    } else {
        throw "Erro ao obter credenciais do AKS"
    }
} catch {
    Write-Host "❌ Erro ao obter credenciais do AKS: $_" -ForegroundColor Red
    exit 1
}

# Verificar se o cluster AKS está acessível
Write-Host "🔍 Verificando conectividade com o cluster..." -ForegroundColor Yellow
try {
    $nodes = kubectl get nodes --no-headers 2>$null
    if ($LASTEXITCODE -eq 0) {
        $nodeCount = ($nodes | Measure-Object).Count
        Write-Host "✅ Cluster acessível - $nodeCount nodes encontrados" -ForegroundColor Green
    } else {
        throw "Cluster não acessível"
    }
} catch {
    Write-Host "❌ Não foi possível acessar o cluster AKS" -ForegroundColor Red
    exit 1
}

# Instalar AGIC addon
Write-Host "📦 Instalando Application Gateway Ingress Controller..." -ForegroundColor Yellow
try {
    Write-Host "   Criando Application Gateway e habilitando AGIC addon..." -ForegroundColor Cyan
    
    $command = "az aks enable-addons " +
               "--resource-group $ResourceGroupName " +
               "--name $AksClusterName " +
               "--addons ingress-appgw " +
               "--appgw-name $AppGatewayName " +
               "--appgw-subnet-cidr $AppGatewaySubnetCidr"
    
    Write-Host "   Executando: $command" -ForegroundColor Gray
    
    Invoke-Expression $command
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ AGIC instalado com sucesso!" -ForegroundColor Green
    } else {
        throw "Erro na instalação do AGIC"
    }
} catch {
    Write-Host "❌ Erro ao instalar AGIC: $_" -ForegroundColor Red
    exit 1
}

# Verificar instalação
Write-Host "🔍 Verificando instalação do AGIC..." -ForegroundColor Yellow
try {
    Start-Sleep -Seconds 30  # Aguardar pods iniciarem
    
    $agicPods = kubectl get pods -n kube-system -l app=ingress-appgw --no-headers 2>$null
    if ($LASTEXITCODE -eq 0 -and $agicPods) {
        Write-Host "✅ Pods do AGIC encontrados:" -ForegroundColor Green
        kubectl get pods -n kube-system -l app=ingress-appgw
    } else {
        Write-Host "⚠️  Pods do AGIC ainda não estão prontos. Aguarde alguns minutos." -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  Não foi possível verificar os pods do AGIC imediatamente" -ForegroundColor Yellow
}

# Mostrar informações do Application Gateway
Write-Host "📊 Informações do Application Gateway:" -ForegroundColor Yellow
try {
    $appgw = az network application-gateway show --resource-group $ResourceGroupName --name $AppGatewayName 2>$null | ConvertFrom-Json
    if ($appgw) {
        Write-Host "   Nome: $($appgw.name)" -ForegroundColor Cyan
        Write-Host "   SKU: $($appgw.sku.name)" -ForegroundColor Cyan
        Write-Host "   Localização: $($appgw.location)" -ForegroundColor Cyan
        Write-Host "   IP Público: $($appgw.frontendIPConfigurations[0].publicIPAddress.id -split '/')[-1]" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️  Não foi possível obter informações detalhadas do Application Gateway" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Instalação do AGIC concluída!" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Próximos passos:" -ForegroundColor Yellow
Write-Host "   1. Aguarde todos os pods do AGIC ficarem prontos (pode levar alguns minutos)" -ForegroundColor White
Write-Host "   2. Crie um Ingress resource para testar:" -ForegroundColor White
Write-Host ""
Write-Host "   Exemplo de Ingress:" -ForegroundColor Cyan
Write-Host @"
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: exemplo-ingress
     annotations:
       kubernetes.io/ingress.class: azure/application-gateway
   spec:
     rules:
     - http:
         paths:
         - path: /
           pathType: Prefix
           backend:
             service:
               name: meu-servico
               port:
                 number: 80
"@ -ForegroundColor Gray

Write-Host ""
Write-Host "   3. Verificar status: kubectl get ingress" -ForegroundColor White
Write-Host "   4. Ver logs: kubectl logs -n kube-system -l app=ingress-appgw" -ForegroundColor White
Write-Host ""
Write-Host "✨ AGIC está pronto para uso!" -ForegroundColor Green
