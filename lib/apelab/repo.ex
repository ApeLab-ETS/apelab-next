defmodule Apelab.Repo do
  use Ecto.Repo,
    otp_app: :apelab,
    adapter: Ecto.Adapters.Postgres
end
