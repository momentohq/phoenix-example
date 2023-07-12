defmodule MomentoExample.Weather do
  require Logger
  require HTTPoison
  alias HTTPoison.{Error, Response}

  @api_url "https://api.open-meteo.com/v1/jma"

  def get_forecast(latitude, longitude) do
    cache_name = Application.get_env(:momento_example, :weather_cache_name)
    cache_client = MomentoExample.CacheClientProvider.get_client()

    case Momento.CacheClient.get(cache_client, cache_name, latitude <> longitude) do
      {:ok, hit} ->
        Logger.debug("Forecast hit for #{latitude <> longitude}")
        data = :erlang.binary_to_term(hit.value)
        {:ok, data}

      :miss ->
        Logger.debug("Forecast miss for #{latitude <> longitude}")

        url =
          "#{@api_url}?latitude=#{latitude}&longitude=#{longitude}&hourly=temperature_2m&timezone=Asia%2FTokyo"

        case HTTPoison.get(url) do
          {:ok, %Response{status_code: 200, body: body}} ->
            # convert the forecast into a list of times to temperatures
            forecast = Jason.decode!(body)
            temperatures = Map.get(forecast, "hourly") |> Map.get("temperature_2m")

            times =
              Map.get(forecast, "hourly")
              |> Map.get("time")
              |> Enum.map(fn time ->
                case DateTime.from_iso8601(time <> ":00Z") do
                  {:ok, datetime, _} -> datetime
                end
              end)

            data = Enum.zip(times, temperatures)

            # store the forecast in Momento with the lat/long as the key
            binary_data = :erlang.term_to_binary(data)
            Momento.CacheClient.set(cache_client, cache_name, latitude <> longitude, binary_data)

            {:ok, data}

          {:ok, %Response{status_code: status_code}} ->
            {:error, "Received status code: #{status_code}"}

          {:error, %Error{reason: reason}} ->
            {:error, reason}
        end

      {:error, error} ->
        {:error, error}
    end
  end
end
