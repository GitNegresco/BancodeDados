from django.db import models


class Cliente(models.Model):
    nome = models.CharField(max_length=100)
    cpf_cnpj = models.CharField(max_length=14, unique=True)
    cnh = models.CharField(max_length=11, blank=True)
    telefone = models.CharField(max_length=15)
    endereco = models.CharField(max_length=255)
    metodo_de_pagamento = models.CharField(max_length=50)

    def __str__(self):
        return self.nome


class Contrato(models.Model):
    contratada = models.CharField(max_length=100)
    contratante = models.CharField(max_length=100)
    cpf_cnpj = models.CharField(max_length=14)
    valor_total = models.DecimalField(max_digits=10, decimal_places=2)
    emails = models.EmailField(max_length=150)
    quilometragem_estimada = models.FloatField()
    valor_entrada = models.DecimalField(max_digits=10, decimal_places=2)
    despesas_contratante = models.DecimalField(max_digits=10, decimal_places=2)
    cliente = models.ForeignKey(Cliente, on_delete=models.PROTECT, related_name="contratos")

    def __str__(self):
        return f"Contrato {self.pk} — {self.contratante}"


class Motorista(models.Model):
    nome = models.CharField(max_length=100)
    cpf = models.CharField(max_length=11, unique=True)
    cnh = models.CharField(max_length=11, unique=True)
    telefone = models.CharField(max_length=15)
    endereco = models.CharField(max_length=255)

    def __str__(self):
        return self.nome


class Veiculo(models.Model):
    placa = models.CharField(max_length=7, unique=True)
    ano = models.PositiveSmallIntegerField()
    modelo = models.CharField(max_length=50)
    marca = models.CharField(max_length=50)
    tanque = models.FloatField()
    lotacao = models.PositiveSmallIntegerField()
    renavam = models.CharField(max_length=11, unique=True)

    def __str__(self):
        return f"{self.placa} — {self.modelo}"


class Viagem(models.Model):
    saida = models.CharField(max_length=150)
    destino = models.CharField(max_length=150)
    observacoes = models.TextField(blank=True)
    partida_em = models.DateTimeField()
    contrato = models.ForeignKey(Contrato, on_delete=models.PROTECT, related_name="viagens")
    motorista = models.ForeignKey(Motorista, on_delete=models.PROTECT, related_name="viagens")
    veiculo = models.ForeignKey(Veiculo, on_delete=models.PROTECT, related_name="viagens")

    def __str__(self):
        return f"{self.saida} → {self.destino}"


class Escala(models.Model):
    n_de_paradas = models.PositiveSmallIntegerField()
    quilometragem = models.FloatField()
    porcentagem_da_viagem = models.FloatField()
    chegada = models.DateTimeField()
    saida = models.DateTimeField()
    viagem = models.ForeignKey(Viagem, on_delete=models.CASCADE, related_name="escalas")

    def __str__(self):
        return f"Escala da viagem {self.viagem_id}"
