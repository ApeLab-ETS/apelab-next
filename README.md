# ApeLab

ApeLab è un'applicazione web moderna per la gestione di eventi e laboratori, costruita con Elixir e Phoenix. L'applicazione permette agli utenti di visualizzare, iscriversi e partecipare a eventi, mentre gli amministratori possono gestire eventi, utenti e contenuti attraverso un pannello di amministrazione dedicato.

## Indice

- [Caratteristiche](#caratteristiche)
- [Architettura](#architettura)
- [Tecnologie](#tecnologie)
- [Prerequisiti](#prerequisiti)
- [Installazione](#installazione)
- [Configurazione](#configurazione)
- [Sviluppo](#sviluppo)
- [Testing](#testing)
- [Deployment](#deployment)
- [Documentazione](#documentazione)
- [Contribuire](#contribuire)
- [Licenza](#licenza)

## Caratteristiche

### Per gli Utenti
- **Registrazione e Autenticazione**: Sistema di autenticazione sicuro basato su Azure B2C
- **Profilo Utente**: Gestione delle informazioni personali e delle preferenze
- **Eventi**: Visualizzazione, ricerca e filtraggio degli eventi disponibili
- **Iscrizioni**: Iscrizione e cancellazione dagli eventi
- **Commenti**: Interazione con altri partecipanti attraverso commenti
- **Notifiche**: Sistema di notifiche per eventi e aggiornamenti

### Per gli Amministratori
- **Dashboard**: Panoramica delle statistiche e attività recenti
- **Gestione Eventi**: Creazione, modifica e cancellazione degli eventi
- **Gestione Utenti**: Amministrazione degli account utente
- **Moderazione**: Gestione dei commenti e contenuti
- **Report**: Generazione di report e analisi

### Tecniche
- **API RESTful**: Interfaccia API completa per integrazioni
- **Interfaccia Responsive**: Design moderno e adattivo con Tailwind CSS
- **Multilingua**: Supporto per Italiano e Inglese
- **SEO**: Ottimizzazione per i motori di ricerca
- **Accessibilità**: Conformità agli standard WCAG 2.1

## Architettura

### Backend
- **Framework**: Phoenix 1.7+
- **Database**: PostgreSQL con Ecto
- **Autenticazione**: Azure B2C
- **API**: RESTful con versioning
- **Caching**: ETS per dati in memoria

### Frontend
- **Template Engine**: HEEx (Phoenix)
- **CSS Framework**: Tailwind CSS
- **JavaScript**: Alpine.js per interattività
- **Assets**: esbuild per bundling

### Infrastruttura
- **Containerizzazione**: Docker
- **CI/CD**: GitHub Actions
- **Monitoring**: Telemetry
- **Logging**: Logger con contesto strutturato

## Tecnologie

### Core
- **Elixir**: 1.14+
- **Erlang/OTP**: 25+
- **Phoenix**: 1.7+
- **Ecto**: 3.10+
- **PostgreSQL**: 12+

### Frontend
- **Tailwind CSS**: 3.3+
- **Alpine.js**: 3.13+
- **esbuild**: 0.19+

### DevOps
- **Docker**: 24+
- **GitHub Actions**: Latest
- **Telemetry**: 1.0+

## Prerequisiti

### Sviluppo
- Elixir 1.14 o superiore
- Erlang/OTP 25 o superiore
- PostgreSQL 12 o superiore
- Node.js 18 o superiore
- Git 2.30 o superiore
- Make 4.0 o superiore

### Produzione
- Docker 24 o superiore
- Docker Compose 2.0 o superiore
- Nginx 1.20 o superiore
- SSL/TLS certificati
- Azure B2C tenant

## Installazione

### Sviluppo Locale

1. Clonare il repository:
   ```bash
   git clone https://github.com/your-username/apelab.git
   cd apelab
   ```

2. Installare le dipendenze di Elixir:
   ```bash
   mix deps.get
   ```

3. Configurare il database:
   ```bash
   mix ecto.setup
   ```

4. Installare le dipendenze JavaScript:
   ```bash
   mix assets.setup
   ```

5. Configurare le variabili d'ambiente:
   ```bash
   cp .env.example .env
   # Modificare .env con i valori appropriati
   ```

### Docker

1. Costruire l'immagine:
   ```bash
   docker build -t apelab .
   ```

2. Eseguire il container:
   ```bash
   docker run -p 4000:4000 apelab
   ```

## Configurazione

### Database

Configurare il database in `config/dev.exs`:
```elixir
config :apelab, Apelab.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "apelab_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

### Azure B2C

Configurare Azure B2C in `config/config.exs`:
```elixir
config :apelab,
  azure_b2c_tenant: System.get_env("AZURE_B2C_TENANT"),
  azure_b2c_client_id: System.get_env("AZURE_B2C_CLIENT_ID"),
  azure_b2c_client_secret: System.get_env("AZURE_B2C_CLIENT_SECRET"),
  azure_b2c_policy: System.get_env("AZURE_B2C_POLICY")
```

### Email

Configurare il servizio email in `config/config.exs`:
```elixir
config :apelab, Apelab.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: System.get_env("SENDGRID_API_KEY")
```

## Sviluppo

### Avvio del Server

1. Avviare il server di sviluppo:
   ```bash
   mix phx.server
   ```

2. Compilare gli assets in modalità watch:
   ```bash
   mix assets.watch
   ```

### Struttura del Progetto

```
apelab/
├── assets/              # Assets frontend
├── config/             # Configurazioni
├── deps/               # Dipendenze
├── docs/               # Documentazione
├── lib/                # Codice sorgente
│   ├── apelab/         # Business logic
│   └── apelab_web/     # Web layer
├── priv/               # File privati
│   ├── repo/           # Migrazioni
│   └── static/         # File statici
└── test/               # Test
```

### Convenzioni di Codice

- **Moduli**: PascalCase (es. `Apelab.Events`)
- **Funzioni**: snake_case (es. `list_public_events`)
- **Variabili**: snake_case (es. `event_params`)
- **Costanti**: SCREAMING_SNAKE_CASE (es. `MAX_PARTICIPANTS`)
- **Indentazione**: 2 spazi
- **Lunghezza riga**: max 100 caratteri

## Testing

### Test Unitari

```bash
# Eseguire tutti i test
mix test

# Eseguire test specifici
mix test test/apelab/events_test.exs

# Eseguire test con coverage
mix test --cover
```

### Test E2E

```bash
# Eseguire test E2E
mix test test/apelab_web/live/event_live_test.exs
```

### Test di Performance

```bash
# Eseguire benchmark
mix run bench/events_bench.exs
```

## Deployment

### Produzione

1. Configurare le variabili d'ambiente per la produzione
2. Eseguire le migrazioni:
   ```bash
   mix ecto.migrate
   ```
3. Compilare gli assets:
   ```bash
   mix assets.deploy
   ```
4. Avviare il server:
   ```bash
   mix phx.server
   ```

### Docker Compose

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "4000:4000"
    environment:
      - DATABASE_URL=postgres://postgres:postgres@db:5432/apelab_prod
    depends_on:
      - db
  db:
    image: postgres:12
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=apelab_prod
```

## Documentazione

- [Documentazione Azure B2C](docs/azure_b2c.md)
- [API Documentation](docs/api.md)
- [Guida Sviluppatore](docs/developer.md)
- [Guida Deployment](docs/deployment.md)
- [Guida Testing](docs/testing.md)

## Contribuire

1. Fork il repository
2. Creare un branch per la feature (`git checkout -b feature/amazing-feature`)
3. Commit delle modifiche (`git commit -m 'Add some amazing feature'`)
4. Push al branch (`git push origin feature/amazing-feature`)
5. Aprire una Pull Request

### Processo di Review

1. **Code Review**: Due approvazioni richieste
2. **Test**: Tutti i test devono passare
3. **Documentazione**: Aggiornare la documentazione se necessario
4. **Squash**: Merge con squash dei commit

## Licenza

Questo progetto è licenziato sotto la licenza MIT - vedere il file [LICENSE](LICENSE) per i dettagli.
