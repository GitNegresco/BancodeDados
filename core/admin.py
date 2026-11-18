from django.contrib import admin

from .models import Cliente, Contrato, Escala, Motorista, Veiculo, Viagem

admin.site.register((Cliente, Contrato, Escala, Motorista, Veiculo, Viagem))
