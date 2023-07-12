defmodule MomentoExample.CacheClientProvider do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    cache_name = Application.get_env(:momento_example, :weather_cache_name)
    config = Application.get_env(:momento_example, :momento_config)
    credential_provider = Application.get_env(:momento_example, :momento_credential_provider)
    client = Momento.CacheClient.create!(config, credential_provider, 3600.0)

    case Momento.CacheClient.create_cache(client, cache_name) do
      {:ok, _} -> :ok
      :already_exists -> :ok
      {:error, error} -> raise error
    end

    {:ok, client}
  end

  def get_client do
    GenServer.call(__MODULE__, :get_client)
  end

  def handle_call(:get_client, _from, client) do
    {:reply, client, client}
  end
end
