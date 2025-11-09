-- Criação de tabelas para Azure SQL (SQL Server)

IF OBJECT_ID('moto', 'U') IS NOT NULL DROP TABLE moto;
IF OBJECT_ID('patio', 'U') IS NOT NULL DROP TABLE patio;
IF OBJECT_ID('usuario', 'U') IS NOT NULL DROP TABLE usuario;
GO

CREATE TABLE usuario (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL
);
GO

CREATE TABLE patio (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);
GO

CREATE TABLE moto (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    placa VARCHAR(20) NOT NULL UNIQUE,
    modelo VARCHAR(50),
    ano INT,
    quilometragem FLOAT,
    status VARCHAR(20),
    usuario_id BIGINT,
    patio_id BIGINT,
    CONSTRAINT fk_moto_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    CONSTRAINT fk_moto_patio FOREIGN KEY (patio_id) REFERENCES patio(id)
);
GO

-- Ajuste as senhas hashadas conforme seu app (placeholder aqui)
INSERT INTO usuario (nome, email, senha, role)
VALUES 
 ('Admin', 'admin@systrack.com', 'SENHA_BCRYPT_ADMIN', 'ADMIN'),
 ('User Demo', 'user@systrack.com', 'SENHA_BCRYPT_USER', 'USER');
GO

INSERT INTO patio (nome, endereco)
VALUES 
 ('Pátio Central', 'Rua Principal, 123'),
 ('Pátio Norte', 'Avenida Norte, 456');
GO

INSERT INTO moto (placa, modelo, ano, quilometragem, status, usuario_id, patio_id)
VALUES 
 ('ABC-1234', 'Honda CG 160', 2020, 15000.5, 'FUNCIONAL', 1, 1),
 ('XYZ1D23', 'Yamaha YBR 125', 2019, 12000.3, 'MANUTENCAO', 2, 2);
GO
