defmodule MomentoExample.Application do
  use Application

  def start(:normal, []) do
    Supervisor.start_link(
      [
        MomentoExample.CacheClientProvider,
        MomentoExampleWeb.Endpoint
      ],
      strategy: :one_for_one
    )
  end
end
