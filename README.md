## 🎯 Visão Geral

O **SysTrack** é um sistema desenvolvido em **Java Spring Boot**, integrado a um **banco de dados Azure SQL** e publicado automaticamente em um **Azure App Service (Linux)** via **pipeline CI/CD no Azure DevOps**.  
O objetivo do projeto foi demonstrar a automação completa do ciclo de desenvolvimento e deploy utilizando práticas de **DevOps**.


Teste
---

## 🧩 Estrutura do Projeto

**Tecnologias e Ferramentas Utilizadas:**
- **Java 17 (Spring Boot 3)**
- **Maven** (build e empacotamento)
- **Azure CLI & PowerShell** (provisionamento de infraestrutura)
- **Azure DevOps Pipelines** (CI/CD)
- **Azure App Service (Linux, B1 Plan)**
- **Azure SQL Database**
- **GitHub / Azure Repos** (versionamento de código)
- **Thymeleaf** (templates HTML)
- **BCrypt** (segurança e autenticação)

---

## ⚙️ Infraestrutura no Azure

Toda a infraestrutura foi criada de forma automatizada com scripts PowerShell:

| Script | Função |
|--------|--------|
| **infra-webapp.ps1** | Cria o grupo de recursos, App Service Plan (Linux), Web App e banco de dados SQL. |
| **config-webapp.ps1** | Configura as variáveis de ambiente (connection strings e App Settings). |
| **deploy-jar.ps1** | Realiza o deploy do arquivo `.jar` gerado para o App Service. |

**Recursos criados no Azure:**
- **Resource Group:** `rg-systrack`
- **App Service Plan:** `asp-systrack-linux`
- **App Service:** `systrack-webapp-david001`
- **Azure SQL Server:** `systracksqlsrvdavid001`
- **Banco de Dados:** `systrackdb`

---

## 🧱 Build e Empacotamento (CI)

O **Continuous Integration (CI)** foi configurado com **Maven** para compilar e empacotar o projeto em um `.jar`.

### 🔧 Pipeline de Build (SysTrack - DevOps)
1. **Get Sources:** clona o repositório do projeto.
2. **Maven Build:** executa: clean package -DskipTests
   
   Isso gera o artefato `SysTrack2-0.0.1-SNAPSHOT.jar` dentro da pasta `target/`.
3. **Copy Files:** copia o `.jar` para a pasta de staging.
4. **Publish Artifact:** publica o artefato `drop` para uso na Release Pipeline.

📁 **Artefato final:**  
`SysTrack2/target/SysTrack2-0.0.1-SNAPSHOT.jar`

---

## 🚀 Deploy Automatizado (CD)

A segunda etapa do pipeline é o **Continuous Deployment (CD)**.

### 🔁 Release Pipeline
1. **Download Artifacts:** obtém o `.jar` gerado no build.
2. **Deploy Azure App Service:**
- **Tipo:** Web App on Linux  
- **Nome:** `systrack-webapp-david001`
- **Subscription:** Azure for Students  
- **Conexão:** Azure Resource Manager

### 🧩 Resultado
O artefato `.jar` é publicado automaticamente no App Service e executado em ambiente Linux.  
A aplicação fica disponível via navegador público no endpoint do App Service.

---

## 🧠 Lógica do Sistema

O sistema implementa controle de usuários, pátios e motos, com autenticação via **Spring Security + BCrypt** e perfis **ADMIN / USER**.

**Principais pacotes:**
- `controller/` → controladores MVC (Login, Moto, Pátio, Usuário)
- `service/` → regras de negócio
- `repository/` → interfaces JPA
- `dto/` → objetos de transferência de dados
- `config/` → segurança (classe `SecurityConfig`)
- `db/migration/` → scripts Flyway de criação e carga inicial

---

## 🔒 Segurança e Autenticação

O login é gerenciado via **Spring Security**, com:
- Autenticação por e-mail e senha.
- Roles (`USER`, `ADMIN`) controlando permissões.
- Redirecionamento seguro pós-login.
- Criptografia de senha com BCrypt.

O usuário **admin** pode realizar operações CRUD em motos, usuários e pátios diretamente via interface web.

---

## 💾 Banco de Dados (Azure SQL)

Banco relacional hospedado no Azure SQL, contendo as tabelas:

| Tabela | Descrição |
|--------|------------|
| `usuario` | Controle de acesso e papéis do sistema |
| `patio` | Cadastro dos pátios monitorados |
| `moto` | Registro de motos associadas a usuários e pátios |

**Script principal:** `script_bd.sql`  
**Script de atualização de admin:** `update_admin.sql`

---

## 🔍 Testes Locais e Validação

Para testes locais:
```bash
mvn clean package -DskipTests
java -jar target/SysTrack2-0.0.1-SNAPSHOT.jar

Para subir novamente no Azure:

`.\infra-webapp.ps1 .\config-webapp.ps1 .\deploy-jar.ps1`

## 📊 Resultados e Conclusão

- ✅ **Integração contínua (CI)** configurada com sucesso via Maven.
    
- ✅ **Deploy contínuo (CD)** automatizado com Azure DevOps + App Service.
    
- ✅ **Banco Azure SQL** conectado e funcional.
    
- ✅ **Ambiente escalável e versionado** pronto para evolução.
    

O projeto SysTrack demonstra o ciclo completo de entrega contínua — desde o código-fonte até a aplicação rodando em ambiente cloud totalmente automatizado.

---

## 👨‍💻 Autoria

**David Gomes**  
RM 556607 – FIAP  
**Disciplina:** DevOps Tools & Cloud Computing  
**Professor:** PF Karlinhos
**Ano:** 2025
