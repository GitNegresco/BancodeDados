START TRANSACTION;

INSERT INTO Clientes (Nome, Documento, Tipo_Pessoa, Telefone, Endereco) VALUES
  ('Ana Souza', '10000000001', 'PF', '11980000001', 'Rua Exemplo, 10, Sao Paulo - SP'),
  ('Bruno Lima', '10000000002', 'PF', '11980000002', 'Rua Exemplo, 20, Sao Paulo - SP'),
  ('Carla Mendes', '10000000003', 'PF', '11980000003', 'Rua Exemplo, 30, Sao Paulo - SP'),
  ('Diego Rocha', '10000000004', 'PF', '11980000004', 'Rua Exemplo, 40, Sao Paulo - SP'),
  ('Elisa Martins', '10000000005', 'PF', '11980000005', 'Rua Exemplo, 50, Sao Paulo - SP'),
  ('Felipe Costa', '10000000006', 'PF', '11980000006', 'Rua Exemplo, 60, Sao Paulo - SP'),
  ('Gabriela Alves', '10000000007', 'PF', '11980000007', 'Rua Exemplo, 70, Sao Paulo - SP'),
  ('Henrique Nunes', '10000000008', 'PF', '11980000008', 'Rua Exemplo, 80, Sao Paulo - SP'),
  ('Isabela Freitas', '10000000009', 'PF', '11980000009', 'Rua Exemplo, 90, Sao Paulo - SP'),
  ('Joao Ribeiro', '10000000010', 'PF', '11980000010', 'Rua Exemplo, 100, Sao Paulo - SP'),
  ('Transportes Aurora Ltda', '12000000000011', 'PJ', '11980000011', 'Rua Exemplo, 110, Sao Paulo - SP'),
  ('Eventos Horizonte Ltda', '12000000000012', 'PJ', '11980000012', 'Rua Exemplo, 120, Sao Paulo - SP'),
  ('Turismo Serra Azul Ltda', '12000000000013', 'PJ', '11980000013', 'Rua Exemplo, 130, Sao Paulo - SP'),
  ('Logistica Vale Verde Ltda', '12000000000014', 'PJ', '11980000014', 'Rua Exemplo, 140, Sao Paulo - SP'),
  ('Excursões Sol Nascente Ltda', '12000000000015', 'PJ', '11980000015', 'Rua Exemplo, 150, Sao Paulo - SP');

INSERT INTO Cliente_Email (fk_Cliente, Email) VALUES
  (1, 'cliente1@exemplo.com'),
  (2, 'cliente2@exemplo.com'),
  (3, 'cliente3@exemplo.com'),
  (4, 'cliente4@exemplo.com'),
  (5, 'cliente5@exemplo.com'),
  (6, 'cliente6@exemplo.com'),
  (7, 'cliente7@exemplo.com'),
  (8, 'cliente8@exemplo.com'),
  (9, 'cliente9@exemplo.com'),
  (10, 'cliente10@exemplo.com'),
  (11, 'cliente11@exemplo.com'),
  (12, 'cliente12@exemplo.com'),
  (13, 'cliente13@exemplo.com'),
  (14, 'cliente14@exemplo.com'),
  (15, 'cliente15@exemplo.com');

INSERT INTO Motoristas (CPF, Nome, CNH, Telefone, Endereco) VALUES
  ('20000000001', 'Marcos Pereira', '30000000001', '11970000001', 'Av. Central, 25, Sao Paulo - SP'),
  ('20000000002', 'Luciana Gomes', '30000000002', '11970000002', 'Av. Central, 50, Sao Paulo - SP'),
  ('20000000003', 'Rafael Dias', '30000000003', '11970000003', 'Av. Central, 75, Sao Paulo - SP'),
  ('20000000004', 'Patricia Araujo', '30000000004', '11970000004', 'Av. Central, 100, Sao Paulo - SP'),
  ('20000000005', 'Eduardo Barros', '30000000005', '11970000005', 'Av. Central, 125, Sao Paulo - SP'),
  ('20000000006', 'Fernanda Lopes', '30000000006', '11970000006', 'Av. Central, 150, Sao Paulo - SP'),
  ('20000000007', 'Gustavo Teixeira', '30000000007', '11970000007', 'Av. Central, 175, Sao Paulo - SP'),
  ('20000000008', 'Camila Cardoso', '30000000008', '11970000008', 'Av. Central, 200, Sao Paulo - SP'),
  ('20000000009', 'Rodrigo Batista', '30000000009', '11970000009', 'Av. Central, 225, Sao Paulo - SP'),
  ('20000000010', 'Vanessa Moreira', '30000000010', '11970000010', 'Av. Central, 250, Sao Paulo - SP');

INSERT INTO Veiculos (Placa, Ano, Modelo, Marca, Tanque, Lotacao, Renavam) VALUES
  ('ABC1D1E', 2021, 'Ducato', 'Fiat', 75.00, 14, '40000000001'),
  ('ABC2D2E', 2022, 'Master', 'Renault', 80.00, 16, '40000000002'),
  ('ABC3D3E', 2023, 'Daily', 'Iveco', 85.00, 18, '40000000003'),
  ('ABC4D4E', 2024, 'Transit', 'Ford', 90.00, 20, '40000000004'),
  ('ABC5D5E', 2025, 'Sprinter', 'Mercedes-Benz', 95.00, 22, '40000000005'),
  ('ABC6D6E', 2020, 'Ducato', 'Fiat', 100.00, 24, '40000000006'),
  ('ABC7D7E', 2021, 'Master', 'Renault', 105.00, 26, '40000000007'),
  ('ABC8D8E', 2022, 'Daily', 'Iveco', 110.00, 28, '40000000008'),
  ('ABC9D9E', 2023, 'Transit', 'Ford', 115.00, 30, '40000000009'),
  ('ABC0D0E', 2024, 'Sprinter', 'Mercedes-Benz', 120.00, 32, '40000000010');

INSERT INTO Contratos (fk_Cliente, Data_Contrato, Valor_Total, Despesas_Contratante, Quilometragem_Estimada, Status) VALUES
  (1, '2026-08-02', 1350.00, 25.00, 130.00, 'concluido'),
  (2, '2026-08-06', 1700.00, 50.00, 160.00, 'concluido'),
  (3, '2026-08-10', 2050.00, 75.00, 190.00, 'concluido'),
  (4, '2026-08-14', 2400.00, 100.00, 220.00, 'concluido'),
  (5, '2026-08-18', 2750.00, 125.00, 250.00, 'concluido'),
  (6, '2026-09-02', 3100.00, 150.00, 280.00, 'concluido'),
  (7, '2026-09-06', 3450.00, 175.00, 310.00, 'concluido'),
  (8, '2026-09-10', 3800.00, 200.00, 340.00, 'concluido'),
  (9, '2026-09-14', 4150.00, 225.00, 370.00, 'aberto'),
  (10, '2026-09-18', 4500.00, 250.00, 400.00, 'aberto'),
  (11, '2026-10-02', 4850.00, 275.00, 430.00, 'aberto'),
  (12, '2026-10-06', 5200.00, 300.00, 460.00, 'aberto'),
  (13, '2026-10-10', 5550.00, 325.00, 490.00, 'aberto'),
  (14, '2026-10-14', 5900.00, 350.00, 520.00, 'cancelado'),
  (15, '2026-10-18', 6250.00, 375.00, 550.00, 'cancelado');

INSERT INTO Pagamentos (fk_Contrato, Data_Pagamento, Valor, Metodo) VALUES
  (1, '2026-08-03', 600.00, 'Cartao'),
  (2, '2026-08-07', 700.00, 'Transferencia'),
  (3, '2026-08-11', 800.00, 'Boleto'),
  (4, '2026-08-15', 900.00, 'PIX'),
  (5, '2026-08-19', 1000.00, 'Cartao'),
  (6, '2026-09-03', 1100.00, 'Transferencia'),
  (7, '2026-09-07', 1200.00, 'Boleto'),
  (8, '2026-09-11', 1300.00, 'PIX'),
  (9, '2026-09-15', 1400.00, 'Cartao'),
  (10, '2026-09-19', 1500.00, 'Transferencia'),
  (11, '2026-10-03', 1600.00, 'Boleto'),
  (12, '2026-10-07', 1700.00, 'PIX'),
  (13, '2026-10-11', 1800.00, 'Cartao'),
  (14, '2026-10-15', 1900.00, 'Transferencia'),
  (15, '2026-10-19', 2000.00, 'Boleto');

INSERT INTO Viagens (fk_Contrato, Origem, Destino, Data_Saida, Data_Retorno, Km_Real, Observacoes) VALUES
  (1, 'Sao Paulo - SP', 'Santos - SP', '2026-08-01 08:00:00', '2026-08-01 19:00:00', 137.00, 'Viagem realizada sem ocorrencias'),
  (2, 'Sao Paulo - SP', 'Sorocaba - SP', '2026-08-02 08:00:00', '2026-08-02 19:00:00', 164.00, 'Viagem realizada sem ocorrencias'),
  (3, 'Sao Paulo - SP', 'Jundiai - SP', '2026-08-03 08:00:00', '2026-08-03 19:00:00', 191.00, 'Viagem realizada sem ocorrencias'),
  (4, 'Sao Paulo - SP', 'Atibaia - SP', '2026-08-04 08:00:00', '2026-08-04 19:00:00', 218.00, 'Viagem realizada sem ocorrencias'),
  (5, 'Sao Paulo - SP', 'Campinas - SP', '2026-08-05 08:00:00', '2026-08-05 19:00:00', 245.00, 'Viagem realizada sem ocorrencias'),
  (6, 'Sao Paulo - SP', 'Santos - SP', '2026-09-01 08:00:00', '2026-09-01 19:00:00', 272.00, 'Viagem realizada sem ocorrencias'),
  (7, 'Sao Paulo - SP', 'Sorocaba - SP', '2026-09-02 08:00:00', '2026-09-02 19:00:00', 299.00, 'Viagem realizada sem ocorrencias'),
  (8, 'Sao Paulo - SP', 'Jundiai - SP', '2026-09-03 08:00:00', '2026-09-03 19:00:00', 326.00, 'Viagem realizada sem ocorrencias'),
  (9, 'Sao Paulo - SP', 'Atibaia - SP', '2026-09-04 08:00:00', '2026-09-04 19:00:00', 353.00, 'Viagem realizada sem ocorrencias'),
  (10, 'Sao Paulo - SP', 'Campinas - SP', '2026-09-05 08:00:00', '2026-09-05 19:00:00', 380.00, 'Viagem realizada sem ocorrencias');

INSERT INTO Viagem_Motorista (fk_Viagem, fk_Motorista, Papel) VALUES
  (1, '20000000001', 'principal'),
  (2, '20000000002', 'principal'),
  (3, '20000000003', 'principal'),
  (4, '20000000004', 'principal'),
  (5, '20000000005', 'principal');

INSERT INTO Viagem_Veiculo (fk_Viagem, fk_Veiculo) VALUES
  (1, 'ABC1D1E'),
  (2, 'ABC2D2E'),
  (3, 'ABC3D3E');

INSERT INTO Escalas (fk_Viagem, Ordem, Local, Quilometragem, Data_Chegada, Data_Saida) VALUES
  (1, 1, 'Posto Anhanguera', 65.00, '2026-08-01 10:00:00', '2026-08-01 10:30:00'),
  (2, 1, 'Parada Litoral', 55.00, '2026-08-02 10:00:00', '2026-08-02 10:20:00');

COMMIT;