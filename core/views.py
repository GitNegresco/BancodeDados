from django.core.serializers.json import DjangoJSONEncoder
from django.db import connection
from django.http import JsonResponse
from django.shortcuts import render
from django.views.decorators.http import require_GET, require_POST

from .management.commands.seed_demo import load_demo_data
from .models import Cliente, Contrato, Escala, Motorista, Veiculo, Viagem


QUERIES = [
    {
        "id": 1,
        "title": "Rotas e responsáveis",
        "description": "Mostra cada viagem com cliente, motorista, veículo e destino.",
        "sql": """SELECT v.id, v.saida, v.destino, c.contratante AS cliente,
                         m.nome AS motorista, f.placa, v.partida_em
                  FROM core_viagem v
                  JOIN core_contrato c ON c.id = v.contrato_id
                  JOIN core_cliente cl ON cl.id = c.cliente_id
                  JOIN core_motorista m ON m.id = v.motorista_id
                  JOIN core_veiculo f ON f.id = v.veiculo_id
                  ORDER BY v.partida_em DESC LIMIT 10""",
    },
    {
        "id": 2,
        "title": "Volume por destino",
        "description": "Agrupa viagens por destino e soma a distância percorrida.",
        "sql": """SELECT v.destino, COUNT(*) AS viagens,
                         ROUND(SUM(e.quilometragem), 1) AS quilometros
                  FROM core_viagem v JOIN core_escala e ON e.viagem_id = v.id
                  GROUP BY v.destino ORDER BY viagens DESC""",
    },
    {
        "id": 3,
        "title": "Contratos de maior valor",
        "description": "Ordena contratos pelo valor total e exibe a entrada.",
        "sql": """SELECT id, contratante, valor_total, valor_entrada,
                         despesas_contratante
                  FROM core_contrato ORDER BY valor_total DESC LIMIT 10""",
    },
    {
        "id": 4,
        "title": "Viagens por motorista",
        "description": "Conta as viagens atribuídas a cada motorista.",
        "sql": """SELECT m.nome AS motorista, COUNT(v.id) AS viagens
                  FROM core_motorista m
                  LEFT JOIN core_viagem v ON v.motorista_id = m.id
                  GROUP BY m.id, m.nome ORDER BY viagens DESC, m.nome""",
    },
    {
        "id": 5,
        "title": "Utilização da frota",
        "description": "Exibe modelo, capacidade e quantidade de viagens por veículo.",
        "sql": """SELECT f.placa, f.marca, f.modelo, f.lotacao,
                         COUNT(v.id) AS viagens
                  FROM core_veiculo f
                  LEFT JOIN core_viagem v ON v.veiculo_id = f.id
                  GROUP BY f.id, f.placa, f.marca, f.modelo, f.lotacao
                  ORDER BY viagens DESC, f.placa""",
    },
    {
        "id": 6,
        "title": "Resumo das escalas",
        "description": "Cruza paradas, distância e percentual com a rota da viagem.",
        "sql": """SELECT v.id AS viagem, v.saida, v.destino, e.n_de_paradas,
                         e.quilometragem, e.porcentagem_da_viagem
                  FROM core_escala e JOIN core_viagem v ON v.id = e.viagem_id
                  ORDER BY e.quilometragem DESC LIMIT 10""",
    },
    {
        "id": 7,
        "title": "Carteira de clientes",
        "description": "Resume contratos e valores contratados por cliente.",
        "sql": """SELECT cl.nome AS cliente, COUNT(c.id) AS contratos,
                         ROUND(COALESCE(SUM(c.valor_total), 0), 2) AS valor_contratado
                  FROM core_cliente cl
                  LEFT JOIN core_contrato c ON c.cliente_id = cl.id
                  GROUP BY cl.id, cl.nome ORDER BY valor_contratado DESC""",
    },
    {
        "id": 8,
        "title": "Distância média por rota",
        "description": "Calcula a quilometragem média e total agrupada por destino.",
        "sql": """SELECT v.destino, ROUND(AVG(e.quilometragem), 1) AS media_km,
                         ROUND(SUM(e.quilometragem), 1) AS total_km
                  FROM core_viagem v JOIN core_escala e ON e.viagem_id = v.id
                  GROUP BY v.destino ORDER BY media_km DESC""",
    },
    {
        "id": 9,
        "title": "Viagens acima da média",
        "description": "Seleciona rotas cuja distância supera a média da operação.",
        "sql": """SELECT v.id, v.saida, v.destino, e.quilometragem
                  FROM core_viagem v JOIN core_escala e ON e.viagem_id = v.id
                  WHERE e.quilometragem >
                        (SELECT AVG(quilometragem) FROM core_escala)
                  ORDER BY e.quilometragem DESC""",
    },
    {
        "id": 10,
        "title": "Painel de indicadores",
        "description": "Retorna uma visão agregada das viagens e da frota.",
        "sql": """SELECT
                      (SELECT COUNT(*) FROM core_viagem) AS total_viagens,
                      (SELECT COUNT(DISTINCT destino) FROM core_viagem) AS destinos,
                      (SELECT ROUND(SUM(quilometragem), 1) FROM core_escala) AS km_total,
                      (SELECT ROUND(AVG(valor_total), 2) FROM core_contrato) AS ticket_medio""",
    },
]


def home(request):
    trips = Viagem.objects.select_related(
        "contrato", "motorista", "veiculo"
    ).order_by("-partida_em")[:8]
    totals = {
        "clientes": Cliente.objects.count(),
        "contratos": Contrato.objects.count(),
        "motoristas": Motorista.objects.count(),
        "veiculos": Veiculo.objects.count(),
        "viagens": Viagem.objects.count(),
        "escalas": Escala.objects.count(),
    }
    return render(
        request,
        "core/dashboard.html",
        {"totals": totals, "trips": trips, "queries": QUERIES},
    )


@require_POST
def seed_demo(request):
    created = load_demo_data()
    if created is None:
        return JsonResponse(
            {"error": "A carga só pode ser aplicada em um banco vazio."},
            status=409,
        )
    return JsonResponse({"created": created, "total": sum(created.values())})


@require_GET
def run_query(request, query_id):
    query = next((item for item in QUERIES if item["id"] == query_id), None)
    if query is None:
        return JsonResponse({"error": "Consulta não encontrada."}, status=404)
    with connection.cursor() as cursor:
        cursor.execute(query["sql"])
        columns = [column[0] for column in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
    return JsonResponse(
        {
            "title": query["title"],
            "description": query["description"],
            "sql": query["sql"].strip(),
            "columns": columns,
            "rows": rows,
        },
        encoder=DjangoJSONEncoder,
    )
