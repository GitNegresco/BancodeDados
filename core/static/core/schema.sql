PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Clientes (
  Id_Cliente INTEGER PRIMARY KEY AUTOINCREMENT,
  Nome VARCHAR(100) NOT NULL,
  Documento VARCHAR(14) NOT NULL UNIQUE,
  Tipo_Pessoa CHAR(2) NOT NULL CHECK (Tipo_Pessoa IN ('PF','PJ')),
  Telefone VARCHAR(15),
  Endereco VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Cliente_Email (
  Id_Email INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_Cliente INTEGER NOT NULL,
  Email VARCHAR(150) NOT NULL,
  UNIQUE (fk_Cliente, Email),
  FOREIGN KEY (fk_Cliente) REFERENCES Clientes(Id_Cliente) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Motoristas (
  CPF VARCHAR(11) PRIMARY KEY,
  Nome VARCHAR(100) NOT NULL,
  CNH VARCHAR(11) NOT NULL UNIQUE,
  Telefone VARCHAR(15),
  Endereco VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Veiculos (
  Placa VARCHAR(7) PRIMARY KEY,
  Ano INTEGER NOT NULL,
  Modelo VARCHAR(50) NOT NULL,
  Marca VARCHAR(50) NOT NULL,
  Tanque DECIMAL(5,2) CHECK (Tanque > 0),
  Lotacao INTEGER NOT NULL CHECK (Lotacao > 0),
  Renavam VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Contratos (
  Id_Contrato INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_Cliente INTEGER NOT NULL,
  Data_Contrato DATE NOT NULL,
  Valor_Total DECIMAL(10,2) NOT NULL CHECK (Valor_Total >= 0),
  Despesas_Contratante DECIMAL(10,2) NOT NULL DEFAULT 0,
  Quilometragem_Estimada DECIMAL(8,2),
  Status VARCHAR(15) NOT NULL DEFAULT 'aberto'
    CHECK (Status IN ('aberto','concluido','cancelado')),
  FOREIGN KEY (fk_Cliente) REFERENCES Clientes(Id_Cliente) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Pagamentos (
  Id_Pagamento INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_Contrato INTEGER NOT NULL,
  Data_Pagamento DATE NOT NULL,
  Valor DECIMAL(10,2) NOT NULL CHECK (Valor > 0),
  Metodo VARCHAR(50) NOT NULL,
  FOREIGN KEY (fk_Contrato) REFERENCES Contratos(Id_Contrato) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Viagens (
  Id_Viagem INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_Contrato INTEGER NOT NULL,
  Origem VARCHAR(150) NOT NULL,
  Destino VARCHAR(150) NOT NULL,
  Data_Saida DATETIME NOT NULL,
  Data_Retorno DATETIME,
  Km_Real DECIMAL(8,2),
  Observacoes TEXT,
  CHECK (Data_Retorno IS NULL OR Data_Retorno >= Data_Saida),
  FOREIGN KEY (fk_Contrato) REFERENCES Contratos(Id_Contrato) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Viagem_Motorista (
  fk_Viagem INTEGER NOT NULL,
  fk_Motorista VARCHAR(11) NOT NULL,
  Papel VARCHAR(20) NOT NULL DEFAULT 'principal',
  PRIMARY KEY (fk_Viagem, fk_Motorista),
  FOREIGN KEY (fk_Viagem) REFERENCES Viagens(Id_Viagem) ON DELETE CASCADE,
  FOREIGN KEY (fk_Motorista) REFERENCES Motoristas(CPF) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Viagem_Veiculo (
  fk_Viagem INTEGER NOT NULL,
  fk_Veiculo VARCHAR(7) NOT NULL,
  PRIMARY KEY (fk_Viagem, fk_Veiculo),
  FOREIGN KEY (fk_Viagem) REFERENCES Viagens(Id_Viagem) ON DELETE CASCADE,
  FOREIGN KEY (fk_Veiculo) REFERENCES Veiculos(Placa) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Escalas (
  Id_Escala INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_Viagem INTEGER NOT NULL,
  Ordem INTEGER NOT NULL,
  Local VARCHAR(150) NOT NULL,
  Quilometragem DECIMAL(8,2) CHECK (Quilometragem >= 0),
  Data_Chegada DATETIME,
  Data_Saida DATETIME,
  UNIQUE (fk_Viagem, Ordem),
  CHECK (Data_Saida IS NULL OR Data_Chegada IS NULL OR Data_Saida >= Data_Chegada),
  FOREIGN KEY (fk_Viagem) REFERENCES Viagens(Id_Viagem) ON DELETE CASCADE
);
