IF OBJECT_ID('usuario', 'U') IS NOT NULL DROP TABLE usuario;
CREATE TABLE usuario (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    senha NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL
);

-- Inserindo usuários iniciais
INSERT INTO usuario (nome, email, senha, role) VALUES
('Administrador', 'admin@systrack.com', 'senha123', 'ADMIN'),
('Usuário Padrão', 'user@systrack.com', '123456', 'USER'),
('Usuário 1', 'user1@systrack.com', '123456', 'USER'),
('Usuário 2', 'user2@systrack.com', '123456', 'USER'),
('Usuário 3', 'user3@systrack.com', '123456', 'USER'),
('Usuário 4', 'user4@systrack.com', '123456', 'USER'),
('Usuário 5', 'user5@systrack.com', '123456', 'USER'),
('Usuário 6', 'user6@systrack.com', '123456', 'USER'),
('Usuário 7', 'user7@systrack.com', '123456', 'USER'),
('Usuário 8', 'user8@systrack.com', '123456', 'USER'),
('Usuário 9', 'user9@systrack.com', '123456', 'USER'),
('Usuário 10', 'user10@systrack.com', '123456', 'USER'),
('Usuário 11', 'user11@systrack.com', '123456', 'USER'),
('Usuário 12', 'user12@systrack.com', '123456', 'USER'),
('Usuário 13', 'user13@systrack.com', '123456', 'USER'),
('Usuário 14', 'user14@systrack.com', '123456', 'USER'),
('Usuário 15', 'user15@systrack.com', '123456', 'USER'),
('Usuário 16', 'user16@systrack.com', '123456', 'USER'),
('Usuário 17', 'user17@systrack.com', '123456', 'USER'),
('Usuário 18', 'user18@systrack.com', '123456', 'USER');

-- ==========================================
-- CRIAÇÃO DA TABELA PÁTIO
-- ==========================================
IF OBJECT_ID('moto', 'U') IS NOT NULL DROP TABLE moto;
IF OBJECT_ID('patio', 'U') IS NOT NULL DROP TABLE patio;
CREATE TABLE patio (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(100) NOT NULL,
    endereco NVARCHAR(255) NOT NULL
);

-- Inserindo pátios iniciais
INSERT INTO patio (nome, endereco) VALUES
('Pátio Central', 'Rua Principal, 123'),
('Pátio Norte', 'Avenida Norte, 456'),
('Pátio Sul', 'Avenida Sul, 789'),
('Pátio Leste', 'Rua Leste, 321'),
('Pátio Oeste', 'Rua Oeste, 654'),
('Pátio Jardim', 'Rua das Flores, 111'),
('Pátio Industrial', 'Avenida das Indústrias, 222'),
('Pátio Comercial', 'Rua do Comércio, 333'),
('Pátio Parque', 'Avenida do Parque, 444'),
('Pátio Estação', 'Rua da Estação, 555'),
('Pátio Aeroporto', 'Avenida Aeroporto, 666'),
('Pátio Porto', 'Rua do Porto, 777'),
('Pátio Lago', 'Avenida do Lago, 888'),
('Pátio Serra', 'Rua da Serra, 999'),
('Pátio Horizonte', 'Avenida Horizonte, 1010'),
('Pátio Universitário', 'Rua da Universidade, 1111'),
('Pátio Vila Nova', 'Rua Vila Nova, 1212'),
('Pátio Campo Belo', 'Avenida Campo Belo, 1313'),
('Pátio Boa Vista', 'Rua Boa Vista, 1414'),
('Pátio Monte Alto', 'Avenida Monte Alto, 1515');

-- ==========================================
-- CRIAÇÃO DA TABELA MOTO
-- ==========================================
CREATE TABLE moto (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    placa NVARCHAR(8) NOT NULL UNIQUE,
    modelo NVARCHAR(50),
    ano INT,
    quilometragem FLOAT,
    status NVARCHAR(20),
    usuario_id BIGINT,
    patio_id BIGINT,
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    CONSTRAINT fk_patio FOREIGN KEY (patio_id) REFERENCES patio(id),
    CONSTRAINT chk_placa CHECK (
        placa LIKE '[A-Z][A-Z][A-Z]-[0-9][0-9][0-9][0-9]' OR
        placa LIKE '[A-Z][A-Z][A-Z][0-9][A-Z][0-9][0-9]'
    )
);

-- Inserindo motos iniciais
INSERT INTO moto (placa, modelo, usuario_id, patio_id, ano, quilometragem, status) VALUES
('ABC-1234', 'Honda CG 160', 1, 1, 2020, 15000.5, 'FUNCIONAL'),
('XYZ1D23', 'Yamaha YBR 125', 2, 2, 2019, 12000.3, 'MANUTENCAO'),
('DVN-1003', 'Honda CB 250F', 3, 3, 2015, 5991.2, 'MANUTENCAO'),
('ECA-1004', 'Honda PCX 150', 4, 4, 2023, 43870.1, 'MANUTENCAO'),
('FJN-1005', 'Honda CG 160', 5, 5, 2017, 47972.4, 'MANUTENCAO'),
('WGZ-1100', 'Yamaha YBR 125', 6, 6, 2017, 47911.4, 'MANUTENCAO');