CREATE TABLE moto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(8) NOT NULL UNIQUE,
    modelo VARCHAR(50),
    ano INT,
    quilometragem DOUBLE,
    status VARCHAR(10),
    usuario_id BIGINT,
    patio_id BIGINT,
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    CONSTRAINT fk_patio FOREIGN KEY (patio_id) REFERENCES patio(id),
    CONSTRAINT chk_placa CHECK (
        placa REGEXP '^[A-Z]{3}-[0-9]{4}$' OR
        placa REGEXP '^[A-Z]{3}[0-9][A-Z][0-9]{2}$'
    )
);
