# Guida Sviluppatore

Questa guida è destinata agli sviluppatori che lavorano sul progetto ApeLab.

## Indice

- [Ambiente di Sviluppo](#ambiente-di-sviluppo)
- [Struttura del Progetto](#struttura-del-progetto)
- [Convenzioni di Codice](#convenzioni-di-codice)
- [Database](#database)
- [Testing](#testing)
- [Deployment](#deployment)
- [Debugging](#debugging)
- [Performance](#performance)

## Ambiente di Sviluppo

### Prerequisiti

- Elixir 1.14+
- Erlang/OTP 25+
- PostgreSQL 12+
- Node.js 18+
- Git 2.30+
- Make 4.0+

### Setup Iniziale

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

4. Installare le dipendenze JavaScript:
   ```bash
   mix assets.setup
   ```

5. Avviare il server di sviluppo:
   ```bash
   mix phx.server
   ```

### Editor

Consigliamo l'uso di Visual Studio Code con le seguenti estensioni:

- ElixirLS
- Phoenix Framework
- Tailwind CSS IntelliSense
- GitLens
- Docker

### Configurazione Editor

#### VS Code

```json
{
  "elixir.enableTestLenses": true,
  "elixir.suggestSpecs": true,
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "jakebecker.elixir-ls",
  "[elixir]": {
    "editor.defaultFormatter": "jakebecker.elixir-ls"
  }
}
```

## Struttura del Progetto

```
apelab/
├── assets/              # Assets frontend
│   ├── css/            # File CSS
│   ├── js/             # File JavaScript
│   └── images/         # Immagini
├── config/             # Configurazioni
│   ├── dev.exs         # Configurazione sviluppo
│   ├── test.exs        # Configurazione test
│   └── prod.exs        # Configurazione produzione
├── deps/               # Dipendenze
├── docs/               # Documentazione
├── lib/                # Codice sorgente
│   ├── apelab/         # Business logic
│   │   ├── events.ex   # Modulo eventi
│   │   ├── users.ex    # Modulo utenti
│   │   └── ...
│   └── apelab_web/     # Web layer
│       ├── controllers/
│       ├── views/
│       ├── templates/
│       └── ...
├── priv/               # File privati
│   ├── repo/           # Migrazioni
│   └── static/         # File statici
└── test/               # Test
    ├── apelab/         # Test business logic
    └── apelab_web/     # Test web layer
```

## Convenzioni di Codice

### Elixir

#### Naming

- **Moduli**: PascalCase (es. `Apelab.Events`)
- **Funzioni**: snake_case (es. `list_public_events`)
- **Variabili**: snake_case (es. `event_params`)
- **Costanti**: SCREAMING_SNAKE_CASE (es. `MAX_PARTICIPANTS`)
- **Atomi**: snake_case (es. `:ok`, `:error`)

#### Formattazione

- Indentazione: 2 spazi
- Lunghezza riga: max 100 caratteri
- Spazi dopo le virgole
- Parentesi per le chiamate di funzione con argomenti

```elixir
defmodule Apelab.Events do
  @moduledoc """
  Modulo per la gestione degli eventi.
  """

  alias Apelab.{Repo, Events.Event}

  @doc """
  Lista gli eventi pubblici con paginazione.
  """
  def list_public_events(params) do
    Event
    |> where([e], e.is_public == true)
    |> where([e], e.status == "planned")
    |> order_by([e], desc: e.start_date)
    |> Repo.paginate(params)
  end
end
```

#### Documentazione

- Utilizzare `@moduledoc` per documentare i moduli
- Utilizzare `@doc` per documentare le funzioni pubbliche
- Utilizzare `@spec` per specificare i tipi
- Seguire il formato [ExDoc](https://hexdocs.pm/ex_doc/)

```elixir
@moduledoc """
Modulo per la gestione degli eventi.
"""

@doc """
Crea un nuovo evento.

## Parametri

  - `attrs` - Map con gli attributi dell'evento

## Valori di ritorno

  - `{:ok, event}` - Se l'evento è stato creato con successo
  - `{:error, changeset}` - Se la creazione è fallita

## Esempi

    iex> create_event(%{title: "Workshop", start_date: ~D[2024-05-01]})
    {:ok, %Event{}}

    iex> create_event(%{title: nil})
    {:error, %Ecto.Changeset{}}
"""
@spec create_event(map()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
def create_event(attrs) do
  %Event{}
  |> Event.changeset(attrs)
  |> Repo.insert()
end
```

### JavaScript

- Utilizzare ES6+
- Utilizzare `const` e `let` invece di `var`
- Utilizzare arrow functions
- Utilizzare template literals
- Utilizzare destructuring

```javascript
const formatDate = (date) => {
  const { year, month, day } = date;
  return `${day}/${month}/${year}`;
};

const fetchEvents = async () => {
  try {
    const response = await fetch('/api/events');
    const { data } = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching events:', error);
    return [];
  }
};
```

### CSS

- Utilizzare Tailwind CSS
- Seguire la metodologia BEM per classi custom
- Utilizzare variabili CSS per colori e dimensioni
- Mantenere la specificità bassa

```css
/* Variabili */
:root {
  --color-primary: #f97316;
  --color-secondary: #1e293b;
  --spacing-base: 1rem;
}

/* Classi custom */
.event-card {
  @apply rounded-lg shadow-md p-4;
}

.event-card__title {
  @apply text-xl font-bold text-gray-900;
}

.event-card__description {
  @apply mt-2 text-gray-600;
}
```

## Database

### Migrazioni

- Nome file: `YYYYMMDDHHMMSS_description.exs`
- Nome modulo: `Apelab.Repo.Migrations.Description`
- Utilizzare `timestamps/0` per `inserted_at` e `updated_at`
- Aggiungere indici per le chiavi esterne
- Utilizzare `references/2` per le relazioni

```elixir
defmodule Apelab.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :description, :text
      add :start_date, :utc_datetime, null: false
      add :end_date, :utc_datetime, null: false
      add :location, :string
      add :max_participants, :integer
      add :status, :string, null: false
      add :tags, {:array, :string}
      add :image_url, :string
      add :latitude, :float
      add :longitude, :float
      add :is_public, :boolean, default: true
      add :organizer_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:organizer_id])
    create index(:events, [:status])
    create index(:events, [:start_date])
  end
end
```

### Schema

- Utilizzare `schema/2` per definire la struttura
- Utilizzare `embedded_schema/1` per i changeset
- Definire i tipi con `@type` e `@typep`
- Utilizzare `@derive` per JSON e Inspect

```elixir
defmodule Apelab.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: integer(),
    title: String.t(),
    description: String.t() | nil,
    start_date: DateTime.t(),
    end_date: DateTime.t(),
    location: String.t() | nil,
    max_participants: integer() | nil,
    status: String.t(),
    tags: list(String.t()),
    image_url: String.t() | nil,
    latitude: float() | nil,
    longitude: float() | nil,
    is_public: boolean(),
    organizer_id: integer(),
    organizer: User.t() | Ecto.Association.NotLoaded.t(),
    participants: list(Participation.t()) | Ecto.Association.NotLoaded.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  schema "events" do
    field :title, :string
    field :description, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :location, :string
    field :max_participants, :integer
    field :status, :string
    field :tags, {:array, :string}
    field :image_url, :string
    field :latitude, :float
    field :longitude, :float
    field :is_public, :boolean, default: true

    belongs_to :organizer, User
    has_many :participants, Participation

    timestamps()
  end

  @required_fields ~w(title start_date end_date status)a
  @optional_fields ~w(description location max_participants tags image_url latitude longitude is_public organizer_id)a

  def changeset(event, attrs) do
    event
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:status, ~w(planned cancelled completed))
    |> validate_number(:max_participants, greater_than: 0)
    |> validate_dates()
  end

  defp validate_dates(changeset) do
    case {get_field(changeset, :start_date), get_field(changeset, :end_date)} do
      {start_date, end_date} when not is_nil(start_date) and not is_nil(end_date) ->
        if DateTime.compare(start_date, end_date) == :lt do
          changeset
        else
          add_error(changeset, :end_date, "must be after start date")
        end
      _ ->
        changeset
    end
  end
end
```

## Testing

### Test Unitari

- Un test per ogni funzione pubblica
- Utilizzare `describe` per raggruppare i test
- Utilizzare `setup` per il setup comune
- Utilizzare `assert` per le asserzioni
- Utilizzare pattern matching per i risultati attesi

```elixir
defmodule Apelab.EventsTest do
  use Apelab.DataCase

  alias Apelab.Events

  describe "events" do
    alias Apelab.Events.Event

    @valid_attrs %{
      title: "Workshop Elixir",
      description: "Workshop introduttivo a Elixir",
      start_date: ~U[2024-05-01 10:00:00Z],
      end_date: ~U[2024-05-01 18:00:00Z],
      location: "Milano",
      max_participants: 20,
      status: "planned",
      tags: ["elixir", "workshop"],
      is_public: true
    }

    @invalid_attrs %{
      title: nil,
      start_date: nil,
      end_date: nil,
      status: nil
    }

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/1 returns paginated events" do
      event = event_fixture()
      assert Events.list_events(%{}) == %{
        entries: [event],
        page_number: 1,
        page_size: 10,
        total_entries: 1,
        total_pages: 1
      }
    end

    test "get_event!/2 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.title == "Workshop Elixir"
      assert event.description == "Workshop introduttivo a Elixir"
      assert event.start_date == ~U[2024-05-01 10:00:00Z]
      assert event.end_date == ~U[2024-05-01 18:00:00Z]
      assert event.location == "Milano"
      assert event.max_participants == 20
      assert event.status == "planned"
      assert event.tags == ["elixir", "workshop"]
      assert event.is_public == true
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end
  end
end
```

### Test di Integrazione

- Testare il flusso completo delle funzionalità
- Utilizzare `Phoenix.ConnTest` per i test HTTP
- Simulare l'autenticazione
- Verificare le risposte HTTP
- Verificare i cambiamenti nel database

```elixir
defmodule ApelabWeb.EventControllerTest do
  use ApelabWeb.ConnCase

  alias Apelab.Events

  @create_attrs %{
    title: "Workshop Elixir",
    description: "Workshop introduttivo a Elixir",
    start_date: ~U[2024-05-01 10:00:00Z],
    end_date: ~U[2024-05-01 18:00:00Z],
    location: "Milano",
    max_participants: 20,
    status: "planned",
    tags: ["elixir", "workshop"],
    is_public: true
  }

  @update_attrs %{
    title: "Workshop Elixir Avanzato",
    description: "Workshop avanzato di Elixir",
    start_date: ~U[2024-05-01 10:00:00Z],
    end_date: ~U[2024-05-01 18:00:00Z],
    location: "Milano",
    max_participants: 30,
    status: "planned",
    tags: ["elixir", "workshop", "advanced"],
    is_public: true
  }

  @invalid_attrs %{
    title: nil,
    start_date: nil,
    end_date: nil,
    status: nil
  }

  def fixture(:event) do
    {:ok, event} = Events.create_event(@create_attrs)
    event
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/events")
      assert html_response(conn, 200) =~ "Events"
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/events/new")
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/events", event: @create_attrs)
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/events/#{id}"

      conn = get(conn, ~p"/events/#{id}")
      assert html_response(conn, 200) =~ "Workshop Elixir"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/events", event: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get(conn, ~p"/events/#{event}/edit")
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup [:create_event]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/events/#{event}", event: @update_attrs)
      assert redirected_to(conn) == ~p"/events/#{event}"

      conn = get(conn, ~p"/events/#{event}")
      assert html_response(conn, 200) =~ "Workshop Elixir Avanzato"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/events/#{event}", event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, ~p"/events/#{event}")
      assert redirected_to(conn) == ~p"/events"

      assert_error_sent 404, fn ->
        get(conn, ~p"/events/#{event}")
      end
    end
  end
end
```

### Test E2E

- Utilizzare Wallaby per i test E2E
- Testare i flussi principali dell'applicazione
- Simulare l'interazione dell'utente
- Verificare il comportamento dell'interfaccia

```elixir
defmodule ApelabWeb.EventLiveTest do
  use ApelabWeb.LiveViewTest

  import Wallaby.Browser
  import Wallaby.Query

  test "user can create an event", %{session: session} do
    session
    |> visit("/events/new")
    |> fill_in(text_field("Title"), with: "Workshop Elixir")
    |> fill_in(text_field("Description"), with: "Workshop introduttivo a Elixir")
    |> fill_in(text_field("Location"), with: "Milano")
    |> fill_in(number_field("Max participants"), with: "20")
    |> click(button("Create Event"))

    assert has_text?(session, "Event created successfully")
    assert has_text?(session, "Workshop Elixir")
  end
end
```

## Deployment

### Produzione

1. Configurare le variabili d'ambiente:
   ```bash
   export SECRET_KEY_BASE="your-secret-key-base"
   export DATABASE_URL="postgres://user:pass@localhost/apelab_prod"
   export AZURE_B2C_TENANT="your-tenant"
   export AZURE_B2C_CLIENT_ID="your-client-id"
   export AZURE_B2C_CLIENT_SECRET="your-client-secret"
   ```

2. Compilare gli assets:
   ```bash
   mix assets.deploy
   ```

3. Eseguire le migrazioni:
   ```bash
   mix ecto.migrate
   ```

4. Avviare il server:
   ```bash
   mix phx.server
   ```

### Docker

1. Costruire l'immagine:
   ```bash
   docker build -t apelab .
   ```

2. Eseguire il container:
   ```bash
   docker run -p 4000:4000 \
     -e SECRET_KEY_BASE="your-secret-key-base" \
     -e DATABASE_URL="postgres://user:pass@db/apelab_prod" \
     -e AZURE_B2C_TENANT="your-tenant" \
     -e AZURE_B2C_CLIENT_ID="your-client-id" \
     -e AZURE_B2C_CLIENT_SECRET="your-client-secret" \
     apelab
   ```

## Debugging

### IEx

- Utilizzare `IEx.pry()` per il debugging interattivo
- Utilizzare `recompile()` per ricompilare il codice
- Utilizzare `h Module.function/arity` per la documentazione

```elixir
def create_event(attrs) do
  IEx.pry() # Breakpoint
  %Event{}
  |> Event.changeset(attrs)
  |> Repo.insert()
end
```

### Logger

- Utilizzare i livelli di log appropriati
- Aggiungere contesto ai messaggi
- Utilizzare strutture per i dati complessi

```elixir
require Logger

def create_event(attrs) do
  Logger.info("Creating event", attrs: attrs)
  # ...
end
```

### Telemetry

- Utilizzare Telemetry per il monitoring
- Tracciare le metriche importanti
- Configurare gli handler appropriati

```elixir
defmodule Apelab.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      counter("apelab.events.created.count",
        description: "Number of events created"
      ),
      summary("apelab.events.created.duration",
        unit: {:native, :millisecond},
        description: "Time taken to create an event"
      )
    ]
  end

  defp periodic_measurements do
    [
      {:apelab, :count, :events}
    ]
  end
end
```

## Performance

### Database

- Utilizzare indici appropriati
- Ottimizzare le query
- Utilizzare Ecto.Query per query complesse
- Utilizzare preload per evitare N+1 queries

```elixir
def list_events_with_participants do
  Event
  |> preload(:participants)
  |> where([e], e.status == "planned")
  |> order_by([e], desc: e.start_date)
  |> Repo.all()
end
```

### Caching

- Utilizzare ETS per dati in memoria
- Utilizzare Redis per dati distribuiti
- Implementare strategie di cache appropriate

```elixir
defmodule Apelab.Cache do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    :ets.new(:cache, [:named_table, :set, :public])
    {:ok, %{}}
  end

  def get(key) do
    case :ets.lookup(:cache, key) do
      [{^key, value}] -> {:ok, value}
      [] -> {:error, :not_found}
    end
  end

  def put(key, value) do
    :ets.insert(:cache, {key, value})
    {:ok, value}
  end
end
```

### Assets

- Minimizzare e comprimere CSS e JavaScript
- Utilizzare CDN per assets statici
- Implementare caching lato client
- Utilizzare lazy loading per le immagini

```javascript
// Lazy loading immagini
document.addEventListener("DOMContentLoaded", function() {
  const images = document.querySelectorAll("img[data-src]");
  const imageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.removeAttribute("data-src");
        observer.unobserve(img);
      }
    });
  });

  images.forEach(img => imageObserver.observe(img));
});
``` 