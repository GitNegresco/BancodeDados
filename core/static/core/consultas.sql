-- 01. Rotas e responsáveis
SELECT v.id, v.saida, v.destino, c.contratante AS cliente,
       m.nome AS motorista, f.placa, v.partida_em
FROM core_viagem v
JOIN core_contrato c ON c.id = v.contrato_id
JOIN core_cliente cl ON cl.id = c.cliente_id
JOIN core_motorista m ON m.id = v.motorista_id
JOIN core_veiculo f ON f.id = v.veiculo_id
ORDER BY v.partida_em DESC LIMIT 10;

-- 02. Volume por destino
SELECT v.destino, COUNT(*) AS viagens,
       ROUND(SUM(e.quilometragem), 1) AS quilometros
FROM core_viagem v
JOIN core_escala e ON e.viagem_id = v.id
GROUP BY v.destino ORDER BY viagens DESC;

-- 03. Contratos de maior valor
SELECT id, contratante, valor_total, valor_entrada, despesas_contratante
FROM core_contrato ORDER BY valor_total DESC LIMIT 10;

-- 04. Viagens por motorista
SELECT m.nome AS motorista, COUNT(v.id) AS viagens
FROM core_motorista m
LEFT JOIN core_viagem v ON v.motorista_id = m.id
GROUP BY m.id, m.nome ORDER BY viagens DESC, m.nome;

-- 05. Utilização da frota
SELECT f.placa, f.marca, f.modelo, f.lotacao, COUNT(v.id) AS viagens
FROM core_veiculo f
LEFT JOIN core_viagem v ON v.veiculo_id = f.id
GROUP BY f.id, f.placa, f.marca, f.modelo, f.lotacao
ORDER BY viagens DESC, f.placa;

-- 06. Resumo das escalas
SELECT v.id AS viagem, v.saida, v.destino, e.n_de_paradas,
       e.quilometragem, e.porcentagem_da_viagem
FROM core_escala e
JOIN core_viagem v ON v.id = e.viagem_id
ORDER BY e.quilometragem DESC LIMIT 10;

-- 07. Carteira de clientes
SELECT cl.nome AS cliente, COUNT(c.id) AS contratos,
       ROUND(COALESCE(SUM(c.valor_total), 0), 2) AS valor_contratado
FROM core_cliente cl
LEFT JOIN core_contrato c ON c.cliente_id = cl.id
GROUP BY cl.id, cl.nome ORDER BY valor_contratado DESC;

-- 08. Distância média por rota
SELECT v.destino, ROUND(AVG(e.quilometragem), 1) AS media_km,
       ROUND(SUM(e.quilometragem), 1) AS total_km
FROM core_viagem v
JOIN core_escala e ON e.viagem_id = v.id
GROUP BY v.destino ORDER BY media_km DESC;

-- 09. Viagens acima da média
SELECT v.id, v.saida, v.destino, e.quilometragem
FROM core_viagem v
JOIN core_escala e ON e.viagem_id = v.id
WHERE e.quilometragem > (SELECT AVG(quilometragem) FROM core_escala)
ORDER BY e.quilometragem DESC;

-- 10. Painel de indicadores
SELECT
    (SELECT COUNT(*) FROM core_viagem) AS total_viagens,
    (SELECT COUNT(DISTINCT destino) FROM core_viagem) AS destinos,
    (SELECT ROUND(SUM(quilometragem), 1) FROM core_escala) AS km_total,
    (SELECT ROUND(AVG(valor_total), 2) FROM core_contrato) AS ticket_medio;
