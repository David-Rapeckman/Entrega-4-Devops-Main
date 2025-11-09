# config-webapp.ps1
# Configura o Web App com connection string e app settings para o SysTrack2.

param(
    [string]$ResourceGroup    = "rg-systrack",
    [string]$WebAppName       = "systrack-webapp-david001",
    [string]$SqlServerName    = "systracksqlsrvdavid001",
    [string]$SqlDbName        = "systrackdb",
    [string]$SqlAdminUser     = "systrackadmin",
    [string]$SqlAdminPassword = "P@ssw0rd-SysTrack123!"
)

Write-Host "==> Validando Web App '$WebAppName'..."
$webAppJson = az webapp show --name $WebAppName --resource-group $ResourceGroup 2>$null
if (-not $webAppJson) {
    Write-Error "Web App não encontrado. Execute 'infra-webapp.ps1' primeiro."
    exit 1
}

Write-Host "==> Configurando connection string do Azure SQL..."
$connectionString = "Server=tcp:$SqlServerName.database.windows.net,1433;Initial Catalog=$SqlDbName;Persist Security Info=False;User ID=$SqlAdminUser;Password=$SqlAdminPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

az webapp config connection-string set `
    --name $WebAppName `
    --resource-group $ResourceGroup `
    --settings "DefaultConnection=$connectionString" `
    --connection-string-type SQLAzure `
    -o none

Write-Host "==> Configurando App Settings (Spring Boot)..."

$jdbcUrl = "jdbc:sqlserver://$SqlServerName.database.windows.net:1433;databaseName=$SqlDbName;encrypt=true;trustServerCertificate=false;loginTimeout=30;"

az webapp config appsettings set `
    --name $WebAppName `
    --resource-group $ResourceGroup `
    --settings `
        "SPRING_DATASOURCE_URL=$jdbcUrl" `
        "SPRING_DATASOURCE_USERNAME=$SqlAdminUser" `
        "SPRING_DATASOURCE_PASSWORD=$SqlAdminPassword" `
        "SPRING_JPA_HIBERNATE_DDL_AUTO=update" `
        "WEBSITES_PORT=8080" `
        "JAVA_OPTS=-Xms512m -Xmx1024m" `
    -o none

Write-Host "✅ Configuração aplicada ao Web App."
