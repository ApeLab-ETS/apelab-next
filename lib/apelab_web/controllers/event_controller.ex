defmodule ApelabWeb.EventController do
  use ApelabWeb, :controller

  alias Apelab.Events

  def index(conn, params) do
    page = Events.list_public_events(
      page: params["page"] || 1,
      page_size: 12
    )
    render(conn, :index, page: page)
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, :show, event: event)
  end
end
