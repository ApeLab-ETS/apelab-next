defmodule Dialyzer.Config do
  def project do
    [
      ignore_warnings: ".dialyzer_ignore.exs",
      plt_add_apps: [:mix, :iex, :logger, :phoenix, :phoenix_live_view, :phoenix_live_reload],
      plt_add_deps: :transitive,
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end
end
