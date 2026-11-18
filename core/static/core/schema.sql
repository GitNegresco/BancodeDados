PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS core_cliente (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(14) NOT NULL UNIQUE,
    cnh VARCHAR(11) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    metodo_de_pagamento VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS core_contrato (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contratada VARCHAR(100) NOT NULL,
    contratante VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(14) NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    emails VARCHAR(150) NOT NULL,
    quilometragem_estimada REAL NOT NULL,
    valor_entrada DECIMAL(10, 2) NOT NULL,
    despesas_contratante DECIMAL(10, 2) NOT NULL,
    cliente_id INTEGER NOT NULL REFERENCES core_cliente(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS core_motorista (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    cnh VARCHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS core_veiculo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    placa VARCHAR(7) NOT NULL UNIQUE,
    ano SMALLINT UNSIGNED NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    tanque REAL NOT NULL,
    lotacao SMALLINT UNSIGNED NOT NULL,
    renavam VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS core_viagem (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    saida VARCHAR(150) NOT NULL,
    destino VARCHAR(150) NOT NULL,
    observacoes TEXT NOT NULL,
    partida_em DATETIME NOT NULL,
    contrato_id INTEGER NOT NULL REFERENCES core_contrato(id) ON DELETE RESTRICT,
    motorista_id INTEGER NOT NULL REFERENCES core_motorista(id) ON DELETE RESTRICT,
    veiculo_id INTEGER NOT NULL REFERENCES core_veiculo(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS core_escala (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    n_de_paradas SMALLINT UNSIGNED NOT NULL,
    quilometragem REAL NOT NULL,
    porcentagem_da_viagem REAL NOT NULL,
    chegada DATETIME NOT NULL,
    saida DATETIME NOT NULL,
    viagem_id INTEGER NOT NULL REFERENCES core_viagem(id) ON DELETE CASCADE
);
