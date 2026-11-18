SELECT c.Id_Cliente, c.Nome, ct.Id_Contrato, ct.Valor_Total, ct.Status
FROM Clientes AS c
INNER JOIN Contratos AS ct ON ct.fk_Cliente = c.Id_Cliente
ORDER BY c.Nome;

SELECT m.CPF, m.Nome AS Motorista, v.Id_Viagem, v.Origem, v.Destino
FROM Motoristas AS m
LEFT JOIN Viagem_Motorista AS vm ON vm.fk_Motorista = m.CPF
LEFT JOIN Viagens AS v ON v.Id_Viagem = vm.fk_Viagem
ORDER BY m.Nome, v.Id_Viagem;

SELECT ve.Placa, ve.Marca, ve.Modelo, v.Id_Viagem, v.Destino
FROM Viagem_Veiculo AS vv
RIGHT JOIN Veiculos AS ve ON ve.Placa = vv.fk_Veiculo
LEFT JOIN Viagens AS v ON v.Id_Viagem = vv.fk_Viagem
ORDER BY ve.Placa, v.Id_Viagem;

SELECT m.Nome AS Motorista, ve.Placa, ve.Modelo
FROM Motoristas AS m
CROSS JOIN Veiculos AS ve
ORDER BY m.Nome, ve.Placa;

SELECT p.Metodo, COUNT(*) AS Quantidade_Pagamentos,
       SUM(p.Valor) AS Total_Recebido, ROUND(AVG(p.Valor), 2) AS Ticket_Medio
FROM Pagamentos AS p
GROUP BY p.Metodo
ORDER BY Total_Recebido DESC;

SELECT ct.Id_Contrato, c.Nome AS Cliente, ct.Valor_Total,
       COALESCE(SUM(p.Valor), 0) AS Total_Pago,
       ct.Valor_Total - COALESCE(SUM(p.Valor), 0) AS Saldo_Pendente
FROM Contratos AS ct
INNER JOIN Clientes AS c ON c.Id_Cliente = ct.fk_Cliente
LEFT JOIN Pagamentos AS p ON p.fk_Contrato = ct.Id_Contrato
GROUP BY ct.Id_Contrato, c.Nome, ct.Valor_Total
HAVING Saldo_Pendente > 0
ORDER BY Saldo_Pendente DESC;

SELECT ct.Id_Contrato, ct.Valor_Total, ct.Status
FROM Contratos AS ct
WHERE ct.Valor_Total > (SELECT AVG(Valor_Total) FROM Contratos)
ORDER BY ct.Valor_Total DESC;

SELECT c.Id_Cliente, c.Nome
FROM Clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM Contratos AS ct
    INNER JOIN Viagens AS v ON v.fk_Contrato = ct.Id_Contrato
    WHERE ct.fk_Cliente = c.Id_Cliente
)
ORDER BY c.Nome;

SELECT DATE_FORMAT(v.Data_Saida, '%Y-%m') AS Mes,
       COUNT(*) AS Quantidade_Viagens,
       COALESCE(SUM(v.Km_Real), 0) AS Km_Total
FROM Viagens AS v
WHERE v.Data_Saida >= '2026-01-01'
  AND v.Data_Saida < '2027-01-01'
GROUP BY YEAR(v.Data_Saida), MONTH(v.Data_Saida)
ORDER BY Mes;

SELECT RANK() OVER (ORDER BY ct.Valor_Total DESC) AS Posicao,
       ct.Id_Contrato, c.Nome AS Cliente, ct.Valor_Total
FROM Contratos AS ct
INNER JOIN Clientes AS c ON c.Id_Cliente = ct.fk_Cliente
ORDER BY Posicao, ct.Id_Contrato;