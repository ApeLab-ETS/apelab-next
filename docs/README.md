# ApeLab Events Platform

## Overview
ApeLab Events è una piattaforma per la gestione e la promozione di eventi. La piattaforma permette agli amministratori di creare e gestire eventi, mentre gli utenti possono visualizzare e partecipare agli eventi pubblici.

## Tecnologie Utilizzate
- Elixir 1.15
- Phoenix 1.7
- PostgreSQL 15
- Tailwind CSS
- Docker

## Requisiti di Sistema
- Elixir 1.15 o superiore
- Erlang 25 o superiore
- PostgreSQL 15 o superiore
- Node.js 18 o superiore
- Yarn

## Configurazione dell'Ambiente di Sviluppo

### Installazione
1. Clona il repository:
```bash
git clone https://github.com/your-username/apelab.git
cd apelab
```

2. Installa le dipendenze:
```bash
mix deps.get
cd assets && yarn install && cd ..
```

3. Configura il database:
```bash
mix ecto.create
mix ecto.migrate
```

4. Avvia il server:
```bash
mix phx.server
```

### Variabili d'Ambiente
Crea un file `.env` nella root del progetto con le seguenti variabili:
```env
DATABASE_URL=postgres://postgres:postgres@localhost:5432/apelab
SECRET_KEY_BASE=your_secret_key_base
```

## Struttura del Progetto
```
apelab/
├── assets/           # Frontend assets
├── lib/             # Codice sorgente
│   ├── apelab/      # Business logic
│   └── apelab_web/  # Web interface
├── priv/            # File privati
│   └── repo/        # Migrations
└── test/            # Test files
```

## Funzionalità Principali

### Gestione Eventi
- Creazione e modifica eventi
- Gestione partecipanti
- Sistema di commenti
- Upload immagini

### Area Amministrativa
- Dashboard admin
- Gestione utenti
- Moderazione commenti
- Statistiche eventi

## Deployment

### Produzione
1. Configura le variabili d'ambiente per la produzione
2. Esegui le migrazioni del database
3. Compila gli assets:
```bash
mix assets.deploy
```
4. Avvia il server Phoenix:
```bash
mix phx.server
```

### Docker
Per deployare con Docker:
```bash
docker build -t apelab .
docker run -p 4000:4000 apelab
```

## Manutenzione

### Database
- Backup giornalieri del database
- Monitoraggio delle performance
- Pulizia dati obsoleti

### Sicurezza
- Aggiornamenti regolari delle dipendenze
- Monitoraggio dei log
- Backup dei dati

## Roadmap Futura

### Fase 1 (Q2 2024)
- [ ] Implementazione sistema di notifiche
- [ ] Miglioramento UI/UX
- [ ] Integrazione con social media

### Fase 2 (Q3 2024)
- [ ] Sistema di ticketing
- [ ] App mobile
- [ ] API pubblica

### Fase 3 (Q4 2024)
- [ ] Sistema di pagamenti
- [ ] Analytics avanzate
- [ ] Integrazione con altri servizi

## Contribuire
1. Fork del repository
2. Crea un branch per la tua feature
3. Commit delle modifiche
4. Push al branch
5. Crea una Pull Request

## Licenza
MIT License 