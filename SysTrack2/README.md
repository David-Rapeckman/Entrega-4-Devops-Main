# 🚀 SysTrack - Deploy no Azure

Integrantes (Nome completo e RM)
Gustavo Rangel — RM 559168
💼 Estudante de Análise e Desenvolvimento de Sistemas na FIAP
🔗 https://linkedin.com/in/gustavoorangel

David Rapeckman — RM 556607
💼 Estudante de Análise e Desenvolvimento de Sistemas na FIAP
🔗 https://linkedin.com/in/davidrapeckman

Luis Felippe Morais — RM 558127
💼 Estudante de Análise e Desenvolvimento de Sistemas na FIAP
🔗 https://linkedin.com/in/luis-felippe-morais-das-neves-16219b2b9

Curso: FIAP – Análise e Desenvolvimento de Sistemas
Disciplina/Entrega: Devops and Cloud Computing


[![Java](https://img.shields.io/badge/Java-17-red)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.0-brightgreen)](https://spring.io/projects/spring-boot)
[![Azure](https://img.shields.io/badge/Azure-App%20Service-blue)](https://azure.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-lightgrey)](https://azure.microsoft.com/services/sql-database/)

Este repositório contém as instruções completas para **deploy** da aplicação **SysTrack** no **Azure App Service** com integração ao **Azure SQL Database**.  
Inclui também seções para **testes** e **validação** do ambiente.



# 🎯 Visão da Solução

Nossa solução tem como objetivo integrar visão computacional às câmeras dos estacionamentos da Mottu, permitindo que o sistema identifique motos automaticamente em tempo real. Através dessa integração, o sistema é capaz de:

Reconhecer placas e características visuais únicas das motos.

Provisionar uma velocidade de verificação que assegure agilidade sem comprometer a precisão.

Diferenciar modelos e estados das motos (ativas, paradas, em manutenção).

Gerar alertas automáticos para irregularidades (ex.: moto fora do pátio, estacionamento indevido).

Consolidar as informações em um painel de monitoramento unificado, otimizando a gestão dos pátios.

Essa abordagem não só aumenta a eficiência operacional, mas também reduz erros humanos, amplia a segurança das filiais e prepara o sistema para futuras integrações com IoT e telemetria em tempo real.

---

## 📂 Estrutura do Repositório

- `README.md` → Guia de deploy e testes.
- `docs/` → Documentação auxiliar.

---

## ⚙️ Configurações Principais

Defina as variáveis de ambiente:

```bash
# Configurações gerais
RG="rg-systrack-java"
LOC="brazilsouth"
PLAN="plan-systrack-java"
APP="systrack-java-001"
WEB_SKU="B1"

# Banco de dados
SQL_SERVER="systrack-sql-001"
SQL_DB="SysTrackDB"
SQL_ADMIN="sqladminuser"
SQL_PASSWORD="asuling1i-das7b3"

# Caminhos locais
DDL_LOCAL="/Users/mylenasena/Entrega-3-Devops/SysTrack2/Full_schema.sql"
JAR_LOCAL="/Users/mylenasena/Entrega-3-Devops/SysTrack2/target/SysTrack2-0.0.1-SNAPSHOT.jar"
```

---

## 📦 Provisionamento de Recursos

### Criar Resource Group
```bash
az group create -n "$RG" -l "$LOC" -o table
```

### Criar App Service Plan
```bash
az appservice plan create \
  --name "$PLAN" \
  --resource-group "$RG" \
  --sku "$WEB_SKU" \
  -o table
```

### Criar WebApp Java
```bash
az webapp create \
  --resource-group "$RG" \
  --plan "$PLAN" \
  --name "$APP" \
  --runtime "JAVA:17" \
  -o table
```

---

## 🗄️ Banco de Dados SQL

### Criar SQL Server
```bash
az sql server create \
  --name "$SQL_SERVER" \
  --resource-group "$RG" \
  --location "$LOC" \
  --admin-user "$SQL_ADMIN" \
  --admin-password "$SQL_PASSWORD" \
  -o table
```

### Criar Database
```bash
az sql db create \
  --resource-group "$RG" \
  --server "$SQL_SERVER" \
  --name "$SQL_DB" \
  --service-objective S0 \
  -o table
```

### Liberar Firewall & IPs
```bash
# Permitir apps dentro do Azure
az sql server firewall-rule create \
  --resource-group "$RG" \
  --server "$SQL_SERVER" \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0 \
  -o table

# Permitir IP atual
MYIP=$(curl -s ifconfig.me -4)
az sql server firewall-rule create \
  --resource-group "$RG" \
  --server "$SQL_SERVER" \
  --name AllowMyIP \
  --start-ip-address $MYIP \
  --end-ip-address $MYIP \
  -o table
```

### Executar Script de Criação do Schema
```bash
sqlcmd -S $SQL_SERVER.database.windows.net \
  -d $SQL_DB \
  -U ${SQL_ADMIN}@${SQL_SERVER} \
  -P $SQL_PASSWORD \
  -i $DDL_LOCAL
```

---

## 🔗 Configuração do WebApp

### Definir Connection String
```bash
DB_URL="jdbc:sqlserver://$SQL_SERVER.database.windows.net:1433;database=$SQL_DB"

az webapp config connection-string set \
  --resource-group "$RG" \
  --name "$APP" \
  --settings DefaultConnection="$DB_URL" \
  --connection-string-type SQLAzure \
  -o table
```

### Definir Comando de Startup
```bash
az webapp config set \
  --resource-group "$RG" \
  --name "$APP" \
  --startup-file "java -jar /home/site/wwwroot/SysTrack2-0.0.1-SNAPSHOT.jar"
```

---

## 🚢 Deploy da Aplicação

> Antes do deploy, execute na pasta onde esta o java e o db:
```bash
mvn clean package -DskipTests
```

### Realizar Deploy do .jar
```bash
az webapp deploy \
  --resource-group "$RG" \
  --name "$APP" \
  --src-path "$JAR_LOCAL" \
  --type jar \
  -o table
```

---

## ✅ Testes e Validação

Após o deploy:

1. **Acessar aplicação**  
   👉 [https://systrack-java-001.azurewebsites.net/login](https://systrack-java-001.azurewebsites.net/login)

2. **Testar conexão com banco**  
   - Login com credenciais cadastradas.  
   - Criar e consultar registros no sistema.  

3. **Logs da aplicação**
   ```bash
   az webapp log tail --resource-group "$RG" --name "$APP"
   ```

---

## 🔮 Próximos Passos

- Configurar **CI/CD** com GitHub Actions ou Azure DevOps.  
- Habilitar **monitoramento** com Azure Monitor e Application Insights.  
- Escalar App Service para produção (`P1v2` ou superior).  
