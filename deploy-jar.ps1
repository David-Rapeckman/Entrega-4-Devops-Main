# deploy-jar.ps1
# Faz deploy do JAR SysTrack2 no App Service criado.

param(
    [string]$ResourceGroup = "rg-systrack",
    [string]$WebAppName    = "systrack-webapp-david001",
    [string]$JarPath       = "./SysTrack2/target/SysTrack2-0.0.1-SNAPSHOT.jar"
)

Write-Host "==> Validando arquivo JAR '$JarPath'..."
if (-not (Test-Path $JarPath)) {
    Write-Error "JAR não encontrado em '$JarPath'. Verifique o caminho ou rode 'mvn clean package' localmente e envie o JAR para o repositório."
    exit 1
}

Write-Host "==> Validando Web App '$WebAppName'..."
$webAppJson = az webapp show --name $WebAppName --resource-group $ResourceGroup 2>$null
if (-not $webAppJson) {
    Write-Error "Web App não encontrado. Execute 'infra-webapp.ps1' antes."
    exit 1
}

Write-Host "==> Realizando deploy do JAR..."
az webapp deploy `
    --resource-group $ResourceGroup `
    --name $WebAppName `
    --type jar `
    --src-path $JarPath `
    -o none

if ($LASTEXITCODE -ne 0) {
    Write-Error "Falha no deploy do JAR."
    exit 1
}

Write-Host "✅ Deploy concluído."
Write-Host "Acesse: https://$WebAppName.azurewebsites.net"
