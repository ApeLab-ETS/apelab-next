defmodule Apelab.Events do
  import Ecto.Query
  alias Apelab.Repo
  alias Apelab.Events.{Event, Participation, Comment}

  @doc """
  Restituisce una lista di tutti gli eventi.
  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Restituisce una lista di eventi pubblici.
  """
  def list_public_events(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    page_size = Keyword.get(opts, :page_size, 10)
    offset = (page - 1) * page_size

    query = Event
    |> where([e], e.is_public == true)
    |> where([e], e.status == :planned)
    |> order_by([e], desc: e.start_date)
    |> limit(^page_size)
    |> offset(^offset)

    %{
      entries: Repo.all(query),
      page_number: page,
      page_size: page_size,
      total_entries: Repo.aggregate(Event, :count, :id),
      total_pages: ceil(Repo.aggregate(Event, :count, :id) / page_size)
    }
  end

  @doc """
  Restituisce il prossimo evento programmato.
  """
  def get_next_event do
    now = DateTime.utc_now()

    Event
    |> where([e], e.is_public == true)
    |> where([e], e.status == :planned)
    |> where([e], e.start_date > ^now)
    |> order_by([e], asc: e.start_date)
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Ottiene un singolo evento.
  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Crea un evento.
  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Aggiorna un evento.
  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Elimina un evento.
  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Crea un changeset per un evento.
  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  @doc """
  Restituisce una lista di partecipazioni per un evento.
  """
  def list_event_participations(%Event{} = event) do
    Participation
    |> where([p], p.event_id == ^event.id)
    |> Repo.all()
  end

  @doc """
  Restituisce una lista di commenti per un evento.
  """
  def list_event_comments(%Event{} = event) do
    Comment
    |> where([c], c.event_id == ^event.id)
    |> Repo.all()
  end
end
