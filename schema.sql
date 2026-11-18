CREATE TABLE Clientes (
  Id_Cliente INT AUTO_INCREMENT PRIMARY KEY,
  Nome VARCHAR(100) NOT NULL,
  Documento VARCHAR(14) NOT NULL UNIQUE,
  Tipo_Pessoa CHAR(2) NOT NULL CHECK (Tipo_Pessoa IN ('PF','PJ')),
  Telefone VARCHAR(15),
  Endereco VARCHAR(255)
);

CREATE TABLE Cliente_Email (
  Id_Email INT AUTO_INCREMENT PRIMARY KEY,
  fk_Cliente INT NOT NULL,
  Email VARCHAR(150) NOT NULL,
  UNIQUE (fk_Cliente, Email),
  FOREIGN KEY (fk_Cliente) REFERENCES Clientes(Id_Cliente) ON DELETE CASCADE
);

CREATE TABLE Motoristas (
  CPF VARCHAR(11) PRIMARY KEY,
  Nome VARCHAR(100) NOT NULL,
  CNH VARCHAR(11) NOT NULL UNIQUE,
  Telefone VARCHAR(15),
  Endereco VARCHAR(255)
);

CREATE TABLE Veiculos (
  Placa VARCHAR(7) PRIMARY KEY,
  Ano INT NOT NULL,
  Modelo VARCHAR(50) NOT NULL,
  Marca VARCHAR(50) NOT NULL,
  Tanque DECIMAL(5,2) CHECK (Tanque > 0),
  Lotacao INT NOT NULL CHECK (Lotacao > 0),
  Renavam VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE Contratos (
  Id_Contrato INT AUTO_INCREMENT PRIMARY KEY,
  fk_Cliente INT NOT NULL,
  Data_Contrato DATE NOT NULL,
  Valor_Total DECIMAL(10,2) NOT NULL CHECK (Valor_Total >= 0),
  Despesas_Contratante DECIMAL(10,2) DEFAULT 0 CHECK (Despesas_Contratante >= 0),
  Quilometragem_Estimada DECIMAL(8,2),
  Status VARCHAR(15) NOT NULL DEFAULT 'aberto'
    CHECK (Status IN ('aberto','concluido','cancelado')),
  FOREIGN KEY (fk_Cliente) REFERENCES Clientes(Id_Cliente) ON DELETE RESTRICT
);

CREATE TABLE Pagamentos (
  Id_Pagamento INT AUTO_INCREMENT PRIMARY KEY,
  fk_Contrato INT NOT NULL,
  Data_Pagamento DATE NOT NULL,
  Valor DECIMAL(10,2) NOT NULL CHECK (Valor > 0),
  Metodo VARCHAR(50) NOT NULL,
  FOREIGN KEY (fk_Contrato) REFERENCES Contratos(Id_Contrato) ON DELETE RESTRICT
);

CREATE TABLE Viagens (
  Id_Viagem INT AUTO_INCREMENT PRIMARY KEY,
  fk_Contrato INT NOT NULL,
  Origem VARCHAR(150) NOT NULL,
  Destino VARCHAR(150) NOT NULL,
  Data_Saida DATETIME NOT NULL,
  Data_Retorno DATETIME,
  Km_Real DECIMAL(8,2),
  Observacoes TEXT,
  CHECK (Data_Retorno IS NULL OR Data_Retorno >= Data_Saida),
  FOREIGN KEY (fk_Contrato) REFERENCES Contratos(Id_Contrato) ON DELETE RESTRICT
);

CREATE TABLE Viagem_Motorista (
  fk_Viagem INT NOT NULL,
  fk_Motorista VARCHAR(11) NOT NULL,
  Papel VARCHAR(20) NOT NULL DEFAULT 'principal',
  PRIMARY KEY (fk_Viagem, fk_Motorista),
  FOREIGN KEY (fk_Viagem) REFERENCES Viagens(Id_Viagem) ON DELETE CASCADE,
  FOREIGN KEY (fk_Motorista) REFERENCES Motoristas(CPF) ON DELETE RESTRICT
);

CREATE TABLE Viagem_Veiculo (
  fk_Viagem INT NOT NULL,
  fk_Veiculo VARCHAR(7) NOT NULL,
  PRIMARY KEY (fk_Viagem, fk_Veiculo),
  FOREIGN KEY (fk_Viagem) REFERENCES Viagens(Id_Viagem) ON DELETE CASCADE,
  FOREIGN KEY (fk_Veiculo) REFERENCES Veiculos(Placa) ON DELETE RESTRICT
);

CREATE TABLE Escalas (
  Id_Escala INT AUTO_INCREMENT PRIMARY KEY,
  fk_Viagem INT NOT NULL,
  Ordem INT NOT NULL,
  Local VARCHAR(150) NOT NULL,
  Quilometragem DECIMAL(8,2) CHECK (Quilometragem >= 0),
  Data_Chegada DATETIME,
  Data_Saida DATETIME,
  UNIQUE (fk_Viagem, Ordem),
  CHECK (Data_Saida IS NULL OR Data_Chegada IS NULL OR Data_Saida >= Data_Chegada),
  FOREIGN KEY (fk_Viagem) REFERENCES Viagens(Id_Viagem) ON DELETE CASCADE
);

CREATE INDEX idx_viagens_data_saida ON Viagens(Data_Saida);
CREATE INDEX idx_vm_motorista_viagem ON Viagem_Motorista(fk_Motorista, fk_Viagem);