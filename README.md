# Rota Clara — banco de dados de logística

Aplicação acadêmica interativa para explorar um banco relacional de transporte. A interface reúne a proposta, requisitos, modelagem, dicionário de dados, scripts, dez consultas SQL, validações e um roteiro de apresentação.

## Executar localmente

```bash
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

Abra `http://127.0.0.1:8000/`. A página **Scripts de criação e carga** explica a estrutura e a carga de demonstração.

## Deploy na Vercel

O projeto usa a detecção automática de Django da Vercel. Importe este repositório
com a raiz do projeto (`./`) como diretório raiz e mantenha o preset Django
detectado automaticamente. A Vercel instala `requirements.txt` e coleta os
arquivos estáticos usando `STATIC_ROOT`.

Antes do deploy, configure `DJANGO_SECRET_KEY` nas variáveis de ambiente do
projeto Vercel para os ambientes Production e Preview. Gere um valor secreto,
por exemplo com `openssl rand -base64 48`; não o adicione ao repositório. Para
usar um domínio personalizado, configure também `DJANGO_ALLOWED_HOSTS` com os
hosts separados por vírgula, sem `https://`. Os domínios `*.vercel.app` já são
permitidos.

O banco SQLite incluído contém os 100 registros fictícios e serve para a
demonstração de leitura e consultas. O armazenamento local das funções Vercel
não é persistente; para guardar alterações entre execuções, configure um banco
gerenciado antes de habilitar gravações em produção.

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
