defmodule ApelabWeb.PageController do
  use ApelabWeb, :controller

  def index(conn, _params) do
    # Recuperiamo gli eventi pubblici più recenti
    events = Apelab.Events.list_public_events(limit: 6)
    # Recuperiamo il prossimo evento
    next_event = Apelab.Events.get_next_event()

    render(conn, :index, events: events, next_event: next_event)
  end

  def about(conn, _params) do
    render(conn, :about)
  end
end
