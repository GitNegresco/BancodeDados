from django.test import TestCase
from django.urls import reverse

from .management.commands.seed_demo import load_demo_data
from .models import Cliente, Contrato, Escala, Motorista, Veiculo, Viagem


class DemoExperienceTests(TestCase):
    def setUp(self):
        load_demo_data()

    def test_dashboard_renders_project_sections(self):
        response = self.client.get(reverse("home"))
        self.assertEqual(response.status_code, 200)
        for page in (
            "inicio",
            "proposta",
            "modelagem",
            "dicionario",
            "scripts",
            "consultas",
        ):
            with self.subTest(page=page):
                self.assertContains(response, f'data-page="{page}"')
        self.assertContains(response, "Dez tabelas do modelo relacional SQL")
        self.assertContains(response, "Popular a demonstração Django")
        self.assertContains(response, "banco da demonstração Django")
        self.assertNotContains(response, "Apresentação")
        self.assertNotContains(response, 'data-page="apresentacao"')

    def test_seed_loads_exactly_one_hundred_related_records(self):
        self.assertEqual(
            Cliente.objects.count()
            + Contrato.objects.count()
            + Motorista.objects.count()
            + Veiculo.objects.count()
            + Viagem.objects.count()
            + Escala.objects.count(),
            100,
        )
        self.assertEqual(Cliente.objects.count(), 10)
        self.assertEqual(Contrato.objects.count(), 15)
        self.assertEqual(Viagem.objects.count(), 20)
        self.assertEqual(Escala.objects.count(), 20)
        self.assertTrue(Viagem.objects.filter(escalas__isnull=False).exists())

    def test_all_ten_queries_execute_and_reloading_is_blocked(self):
        for query_id in range(1, 11):
            with self.subTest(query_id=query_id):
                response = self.client.get(
                    reverse("run_query", args=[query_id])
                )
                self.assertEqual(response.status_code, 200)
                self.assertTrue(response.json()["rows"])

        response = self.client.post(reverse("seed_demo"))
        self.assertEqual(response.status_code, 409)
