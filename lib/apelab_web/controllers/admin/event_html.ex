defmodule ApelabWeb.Admin.EventHTML do
  use ApelabWeb, :html

  embed_templates "event_html/*"

  def status_color(status) do
    case status do
      "planned" -> "bg-green-100 text-green-800"
      "cancelled" -> "bg-red-100 text-red-800"
      "completed" -> "bg-gray-100 text-gray-800"
      _ -> "bg-gray-100 text-gray-800"
    end
  end
end
