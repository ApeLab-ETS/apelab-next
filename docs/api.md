# API Documentation

Questo documento descrive l'API RESTful di ApeLab.

## Indice

- [Panoramica](#panoramica)
- [Autenticazione](#autenticazione)
- [Endpoints](#endpoints)
- [Modelli](#modelli)
- [Errori](#errori)
- [Rate Limiting](#rate-limiting)
- [Versioning](#versioning)

## Panoramica

L'API di ApeLab è basata su REST e utilizza JSON per lo scambio dei dati. Tutte le richieste devono essere effettuate tramite HTTPS.

### Base URL

```
https://api.apelab.example.com/v1
```

### Formato delle Risposte

Tutte le risposte sono in formato JSON e seguono questa struttura:

```json
{
  "data": {
    // Dati della risposta
  },
  "meta": {
    // Metadati (paginazione, etc.)
  }
}
```

## Autenticazione

L'API utilizza token JWT per l'autenticazione. Il token deve essere incluso nell'header `Authorization` di ogni richiesta:

```
Authorization: Bearer <token>
```

### Ottenere un Token

```http
POST /auth/token
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password"
}
```

Risposta:
```json
{
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600
  }
}
```

## Endpoints

### Eventi

#### Lista Eventi

```http
GET /events
```

Parametri query:
- `page` (opzionale): Numero di pagina (default: 1)
- `per_page` (opzionale): Elementi per pagina (default: 10)
- `status` (opzionale): Filtra per stato (planned, cancelled, completed)
- `start_date` (opzionale): Filtra per data di inizio (ISO 8601)
- `end_date` (opzionale): Filtra per data di fine (ISO 8601)

Risposta:
```json
{
  "data": [
    {
      "id": "1",
      "type": "event",
      "attributes": {
        "title": "Workshop Elixir",
        "description": "Workshop introduttivo a Elixir",
        "start_date": "2024-05-01T10:00:00Z",
        "end_date": "2024-05-01T18:00:00Z",
        "location": "Milano",
        "max_participants": 20,
        "status": "planned",
        "tags": ["elixir", "workshop"],
        "image_url": "https://example.com/images/workshop.jpg",
        "latitude": 45.4642,
        "longitude": 9.1900,
        "is_public": true
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "total_count": 42
  }
}
```

#### Dettaglio Evento

```http
GET /events/:id
```

Risposta:
```json
{
  "data": {
    "id": "1",
    "type": "event",
    "attributes": {
      "title": "Workshop Elixir",
      "description": "Workshop introduttivo a Elixir",
      "start_date": "2024-05-01T10:00:00Z",
      "end_date": "2024-05-01T18:00:00Z",
      "location": "Milano",
      "max_participants": 20,
      "status": "planned",
      "tags": ["elixir", "workshop"],
      "image_url": "https://example.com/images/workshop.jpg",
      "latitude": 45.4642,
      "longitude": 9.1900,
      "is_public": true,
      "organizer": {
        "id": "1",
        "name": "John Doe",
        "email": "john@example.com"
      },
      "participants": [
        {
          "id": "1",
          "name": "Jane Smith",
          "email": "jane@example.com"
        }
      ]
    }
  }
}
```

#### Creazione Evento

```http
POST /events
Content-Type: application/json
Authorization: Bearer <token>

{
  "data": {
    "type": "event",
    "attributes": {
      "title": "Workshop Elixir",
      "description": "Workshop introduttivo a Elixir",
      "start_date": "2024-05-01T10:00:00Z",
      "end_date": "2024-05-01T18:00:00Z",
      "location": "Milano",
      "max_participants": 20,
      "tags": ["elixir", "workshop"],
      "image_url": "https://example.com/images/workshop.jpg",
      "latitude": 45.4642,
      "longitude": 9.1900,
      "is_public": true
    }
  }
}
```

#### Aggiornamento Evento

```http
PATCH /events/:id
Content-Type: application/json
Authorization: Bearer <token>

{
  "data": {
    "type": "event",
    "id": "1",
    "attributes": {
      "title": "Workshop Elixir Avanzato",
      "max_participants": 30
    }
  }
}
```

#### Eliminazione Evento

```http
DELETE /events/:id
Authorization: Bearer <token>
```

### Partecipazioni

#### Iscrizione a un Evento

```http
POST /events/:event_id/participations
Authorization: Bearer <token>
```

Risposta:
```json
{
  "data": {
    "id": "1",
    "type": "participation",
    "attributes": {
      "event_id": "1",
      "user_id": "1",
      "status": "confirmed",
      "created_at": "2024-04-21T10:00:00Z"
    }
  }
}
```

#### Cancellazione Iscrizione

```http
DELETE /events/:event_id/participations
Authorization: Bearer <token>
```

### Commenti

#### Lista Commenti di un Evento

```http
GET /events/:event_id/comments
```

Risposta:
```json
{
  "data": [
    {
      "id": "1",
      "type": "comment",
      "attributes": {
        "content": "Ottimo workshop!",
        "user": {
          "id": "1",
          "name": "Jane Smith"
        },
        "created_at": "2024-04-21T10:00:00Z"
      }
    }
  ]
}
```

#### Aggiunta Commento

```http
POST /events/:event_id/comments
Content-Type: application/json
Authorization: Bearer <token>

{
  "data": {
    "type": "comment",
    "attributes": {
      "content": "Ottimo workshop!"
    }
  }
}
```

## Modelli

### Event

```json
{
  "id": "string",
  "type": "event",
  "attributes": {
    "title": "string",
    "description": "string",
    "start_date": "datetime",
    "end_date": "datetime",
    "location": "string",
    "max_participants": "integer",
    "status": "string",
    "tags": ["string"],
    "image_url": "string",
    "latitude": "float",
    "longitude": "float",
    "is_public": "boolean",
    "organizer": {
      "id": "string",
      "name": "string",
      "email": "string"
    },
    "participants": [
      {
        "id": "string",
        "name": "string",
        "email": "string"
      }
    ]
  }
}
```

### Participation

```json
{
  "id": "string",
  "type": "participation",
  "attributes": {
    "event_id": "string",
    "user_id": "string",
    "status": "string",
    "created_at": "datetime"
  }
}
```

### Comment

```json
{
  "id": "string",
  "type": "comment",
  "attributes": {
    "content": "string",
    "user": {
      "id": "string",
      "name": "string"
    },
    "created_at": "datetime"
  }
}
```

## Errori

Le risposte di errore seguono questo formato:

```json
{
  "errors": [
    {
      "status": "400",
      "title": "Bad Request",
      "detail": "Invalid parameters",
      "source": {
        "pointer": "/data/attributes/title"
      }
    }
  ]
}
```

### Codici di Errore

- `400 Bad Request`: Parametri non validi
- `401 Unauthorized`: Token mancante o non valido
- `403 Forbidden`: Permessi insufficienti
- `404 Not Found`: Risorsa non trovata
- `422 Unprocessable Entity`: Validazione fallita
- `429 Too Many Requests`: Rate limit superato
- `500 Internal Server Error`: Errore del server

## Rate Limiting

L'API implementa rate limiting per prevenire l'abuso. I limiti sono:

- 100 richieste per minuto per IP
- 1000 richieste per ora per utente autenticato

Gli headers di risposta includono:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1523456789
```

## Versioning

L'API è versionata attraverso l'URL. La versione corrente è v1:

```
https://api.apelab.example.com/v1
```

Le versioni precedenti sono mantenute per un periodo di 12 mesi dopo il rilascio di una nuova versione. 