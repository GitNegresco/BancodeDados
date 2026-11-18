# Rota Clara — banco de dados de logística

Aplicação acadêmica interativa para explorar um banco relacional de transporte. A interface reúne a proposta, requisitos, modelagem, dicionário de dados, scripts, dez consultas SQL, validações e um roteiro de apresentação.

## Executar localmente

```bash
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

Abra `http://127.0.0.1:8000/`. A página **Scripts de criação e carga** explica a estrutura e a carga de demonstração.

## Carga de demonstração

Carregue os dados pelo botão no cabeçalho ou pelo comando:

```bash
python manage.py seed_demo
```

A carga adiciona exatamente 100 registros fictícios:

| Entidade | Registros |
| --- | ---: |
| Clientes | 10 |
| Contratos | 15 |
| Motoristas | 20 |
| Veículos | 15 |
| Viagens | 20 |
| Escalas | 20 |
| **Total** | **100** |

O comando e o botão só executam em um banco sem registros do projeto. Isso evita duplicar dados ou sobrescrever conteúdo existente. Para reiniciar um ambiente de demonstração, recrie o banco local antes de aplicar as migrações e executar a carga.

## Estrutura e arquivos SQL

- `core/models.py`: entidades e relacionamentos implementados pelo Django.
- `core/migrations/`: criação versionada do esquema SQLite.
- `core/management/commands/seed_demo.py`: geração determinística dos registros fictícios.
- `core/static/core/schema.sql`: DDL SQLite equivalente ao esquema.
- `core/static/core/consultas.sql`: as dez consultas SQL disponíveis na interface.
- `core/templates/core/dashboard.html` e `core/static/core/app.css`: interface responsiva em português com Tailwind CSS.

As consultas da demonstração são predefinidas e executadas em modo somente leitura. Use a página **Consultas & validações** para executar e inspecionar os resultados.
