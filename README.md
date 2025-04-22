# ApeLab

ApeLab è un'applicazione web per la gestione di eventi e laboratori, costruita con Elixir e Phoenix.

## Caratteristiche

- Gestione eventi e laboratori
- Autenticazione utenti con Azure B2C
- Pannello di amministrazione
- API RESTful
- Interfaccia moderna con Tailwind CSS
- Supporto multilingua (Italiano/Inglese)

## Tecnologie

- Elixir 1.14+
- Phoenix 1.7+
- PostgreSQL
- Tailwind CSS
- Azure B2C
- Docker

## Prerequisiti

- Elixir 1.14 o superiore
- Erlang/OTP 25 o superiore
- PostgreSQL 12 o superiore
- Node.js 18 o superiore (per assets)
- Docker (opzionale)

## Installazione

1. Clonare il repository:
   ```bash
   git clone https://github.com/your-username/apelab.git
   cd apelab
   ```

2. Installare le dipendenze:
   ```bash
   mix deps.get
   ```

3. Configurare il database:
   ```bash
   mix ecto.setup
   ```

4. Installare le dipendenze degli assets:
   ```bash
   mix assets.setup
   ```

5. Configurare le variabili d'ambiente:
   ```bash
   cp .env.example .env
   # Modificare .env con i valori appropriati
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

## Sviluppo

1. Avviare il server di sviluppo:
   ```bash
   mix phx.server
   ```

2. Compilare gli assets in modalità watch:
   ```bash
   mix assets.watch
   ```

3. Eseguire i test:
   ```bash
   mix test
   ```

## Deployment

### Docker

1. Costruire l'immagine:
   ```bash
   docker build -t apelab .
   ```

2. Eseguire il container:
   ```bash
   docker run -p 4000:4000 apelab
   ```

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

## Documentazione

- [Documentazione Azure B2C](docs/azure_b2c.md)
- [API Documentation](docs/api.md)
- [Guida Sviluppatore](docs/developer.md)

## Contribuire

1. Fork il repository
2. Creare un branch per la feature (`git checkout -b feature/amazing-feature`)
3. Commit delle modifiche (`git commit -m 'Add some amazing feature'`)
4. Push al branch (`git push origin feature/amazing-feature`)
5. Aprire una Pull Request

## Licenza

Questo progetto è licenziato sotto la licenza MIT - vedere il file [LICENSE](LICENSE) per i dettagli.
