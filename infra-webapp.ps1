# infra-webapp.ps1
# Provisiona toda a infraestrutura no Azure via CLI para o SysTrack2.
# Requisitos:
# - az login executado antes
# - Execução no Azure Cloud Shell ou PowerShell com AZ CLI instalado

param(
    [string]$Location         = "brazilsouth",
    [string]$ResourceGroup    = "rg-systrack",
    [string]$AppServicePlan   = "asp-systrack-linux",
    # Web App precisa ser único globalmente
    [string]$WebAppName       = "systrack-webapp-david001",
    # SQL Server também precisa ser único globalmente
    [string]$SqlServerName    = "systracksqlsrvdavid001",
    [string]$SqlAdminUser     = "systrackadmin",
    [string]$SqlAdminPassword = "P@ssw0rd-SysTrack123!",
    [string]$SqlDbName        = "systrackdb"
)

Write-Host "==> Validando login no Azure..."
az account show 1>$null 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Você não está logado. Rode 'az login' e execute o script novamente."
    exit 1
}

# Resource Group
Write-Host "==> Validando Resource Group '$ResourceGroup'..."
$rgExists = az group exists -n $ResourceGroup
if ($rgExists -eq "false") {
    Write-Host "    Criando Resource Group..."
    az group create --name $ResourceGroup --location $Location -o none
} else {
    Write-Host "    Resource Group já existe. Reutilizando."
}

# App Service Plan (Linux)
Write-Host "==> Validando App Service Plan '$AppServicePlan'..."
$planJson = az appservice plan show --name $AppServicePlan --resource-group $ResourceGroup 2>$null
if (-not $planJson) {
    Write-Host "    Criando App Service Plan Linux (B1)..."
    az appservice plan create `
        --name $AppServicePlan `
        --resource-group $ResourceGroup `
        --location $Location `
        --sku B1 `
        --is-linux -o none
} else {
    Write-Host "    App Service Plan já existe. Reutilizando."
}

# Descobrir runtime Java 17
Write-Host "==> Obtendo runtime Java 17 suportado para Linux..."
$javaRuntime = az webapp list-runtimes --os-type linux `
    --query "[?contains(@, 'JAVA') && contains(@, '17')][0]" -o tsv

if (-not $javaRuntime) {
    Write-Error "Runtime Java 17 não encontrado. Rode 'az webapp list-runtimes --os-type linux' manualmente e ajuste neste script."
    exit 1
}

Write-Host "    Usando runtime: $javaRuntime"

# Web App
Write-Host "==> Validando Web App '$WebAppName'..."
$webAppJson = az webapp show --name $WebAppName --resource-group $ResourceGroup 2>$null
if (-not $webAppJson) {
    Write-Host "    Criando Web App..."
    az webapp create `
        --name $WebAppName `
        --resource-group $ResourceGroup `
        --plan $AppServicePlan `
        --runtime "$javaRuntime" `
        -o none
} else {
    Write-Host "    Web App já existe. Reutilizando."
}

# Azure SQL Server
Write-Host "==> Validando Azure SQL Server '$SqlServerName'..."
$sqlServerJson = az sql server show --name $SqlServerName --resource-group $ResourceGroup 2>$null
if (-not $sqlServerJson) {
    Write-Host "    Criando Azure SQL Server..."
    az sql server create `
        --name $SqlServerName `
        --resource-group $ResourceGroup `
        --location $Location `
        --admin-user $SqlAdminUser `
        --admin-password $SqlAdminPassword `
        -o none

    Write-Host "    Criando regra de firewall para Serviços Azure..."
    az sql server firewall-rule create `
        --name AllowAzureServices `
        --resource-group $ResourceGroup `
        --server $SqlServerName `
        --start-ip-address 0.0.0.0 `
        --end-ip-address 0.0.0.0 `
        -o none
} else {
    Write-Host "    SQL Server já existe. Reutilizando."
}

# Database
Write-Host "==> Validando Database '$SqlDbName'..."
$sqlDbJson = az sql db show --name $SqlDbName --server $SqlServerName --resource-group $ResourceGroup 2>$null
if (-not $sqlDbJson) {
    Write-Host "    Criando Database..."
    az sql db create `
        --name $SqlDbName `
        --server $SqlServerName `
        --resource-group $ResourceGroup `
        --service-objective S0 `
        -o none
} else {
    Write-Host "    Database já existe. Reutilizando."
}

Write-Host "✅ Infraestrutura provisionada/validada com sucesso."
