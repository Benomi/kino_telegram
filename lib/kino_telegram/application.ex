defmodule KinoTelegram.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoTelegram.MessageCell)

    children = []
    opts = [strategy: :one_for_one, name: KinoTelegram.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
