from datetime import datetime, timedelta, timezone
from decimal import Decimal

from django.core.management.base import BaseCommand, CommandError
from django.db import transaction

from core.models import Cliente, Contrato, Escala, Motorista, Veiculo, Viagem


def load_demo_data():
    models = (Cliente, Contrato, Motorista, Veiculo, Viagem, Escala)
    if any(model.objects.exists() for model in models):
        return None

    cities = [
        "São Paulo, SP",
        "Campinas, SP",
        "Santos, SP",
        "Rio de Janeiro, RJ",
        "Curitiba, PR",
        "Belo Horizonte, MG",
        "Brasília, DF",
        "Florianópolis, SC",
        "Goiânia, GO",
        "Porto Alegre, RS",
    ]
    first_names = [
        "Ana", "Bruno", "Camila", "Diego", "Elisa", "Felipe", "Giovana",
        "Henrique", "Isabela", "João", "Karen", "Lucas", "Marina", "Nicolas",
        "Olivia", "Pedro", "Rafaela", "Samuel", "Tainá", "Victor",
    ]
    last_names = [
        "Almeida", "Barbosa", "Costa", "Dias", "Esteves", "Ferreira",
        "Gomes", "Henriques", "Ibrahim", "Jardim", "Lima", "Mendes",
        "Nogueira", "Oliveira", "Pereira", "Queiroz", "Ramos", "Silva",
        "Teixeira", "Vieira",
    ]

    with transaction.atomic():
        clients = [
            Cliente.objects.create(
                nome=f"{first_names[i]} {last_names[(i + 5) % 20]}",
                cpf_cnpj=f"90000000000{i:03d}",
                cnh=f"{80000000000 + i:011d}",
                telefone=f"+55 11 9{i:02d}00-{1000 + i:04d}",
                endereco=f"Rua das Flores, {100 + i} — {cities[i % 10]}",
                metodo_de_pagamento=("PIX", "Transferência", "Boleto")[i % 3],
            )
            for i in range(10)
        ]
        contracts = [
            Contrato.objects.create(
                contratada="Rota Clara Transportes",
                contratante=clients[i % 10].nome,
                cpf_cnpj=clients[i % 10].cpf_cnpj,
                valor_total=Decimal(8500 + i * 725) + Decimal("0.90"),
                emails=f"contato{i + 1}@exemplo.com",
                quilometragem_estimada=480 + i * 115,
                valor_entrada=Decimal(1500 + i * 125),
                despesas_contratante=Decimal(320 + i * 40),
                cliente=clients[i % 10],
            )
            for i in range(15)
        ]
        drivers = [
            Motorista.objects.create(
                nome=f"{first_names[i]} {last_names[(i + 9) % 20]}",
                cpf=f"70000000{i:03d}",
                cnh=f"{60000000000 + i:011d}",
                telefone=f"+55 11 9{i:02d}11-{2000 + i:04d}",
                endereco=f"Av. do Transporte, {200 + i} — {cities[i % 10]}",
            )
            for i in range(20)
        ]
        vehicles = [
            Veiculo.objects.create(
                placa=f"FRT{i:04d}"[-7:],
                ano=2019 + i % 7,
                modelo=("Cargo 2429", "Actros 2651", "Delivery 11.180")[i % 3],
                marca=("Ford", "Mercedes-Benz", "Volkswagen")[i % 3],
                tanque=250 + (i % 5) * 35,
                lotacao=8 + (i % 4) * 3,
                renavam=f"{50000000000 + i:011d}",
            )
            for i in range(15)
        ]
        trips = []
        for i in range(20):
            departure = datetime(2026, 1, 5, 7, 30, tzinfo=timezone.utc) + timedelta(days=i * 3)
            trip = Viagem.objects.create(
                saida=cities[i % 10],
                destino=cities[(i * 3 + 2) % 10],
                observacoes=(
                    "Entrega fracionada — carga paletizada."
                    if i % 2 == 0
                    else "Coleta agendada — conferir documentação."
                ),
                partida_em=departure,
                contrato=contracts[i % 15],
                motorista=drivers[i],
                veiculo=vehicles[i % 15],
            )
            trips.append(trip)
        for i, trip in enumerate(trips):
            Escala.objects.create(
                n_de_paradas=1 + i % 5,
                quilometragem=round(185 + i * 47.5, 1),
                porcentagem_da_viagem=100,
                chegada=trip.partida_em + timedelta(hours=5 + i % 8),
                saida=trip.partida_em,
                viagem=trip,
            )

    return {
        "clientes": len(clients),
        "contratos": len(contracts),
        "motoristas": len(drivers),
        "veiculos": len(vehicles),
        "viagens": len(trips),
        "escalas": len(trips),
    }


class Command(BaseCommand):
    help = "Carrega 100 registros fictícios de demonstração em um banco vazio."

    def handle(self, *args, **options):
        created = load_demo_data()
        if created is None:
            raise CommandError(
                "A carga só pode ser aplicada em um banco vazio; nenhum dado foi alterado."
            )
        self.stdout.write(
            self.style.SUCCESS(f"Carga concluída: {sum(created.values())} registros.")
        )
