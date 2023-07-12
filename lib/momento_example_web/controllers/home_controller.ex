defmodule MomentoExampleWeb.HomeController do
  use Phoenix.Controller, namespace: MomentoExampleWeb

  alias MomentoExample.Weather

  def show(conn, %{"latitude" => latitude, "longitude" => longitude}) do
    rounded_lat = round_to_one_decimal(latitude)
    rounded_lon = round_to_one_decimal(longitude)

    case Weather.get_forecast(rounded_lat, rounded_lon) do
      {:ok, forecast} ->
        ds = Contex.Dataset.new(forecast, ["time", "temp"])
        chart = Contex.LinePlot.new(ds)

        plot =
          Contex.Plot.new(600, 400, chart)
          |> Contex.Plot.titles("Hourly temperature for #{rounded_lat}, #{rounded_lon}", "")

        {:safe, svg} = Contex.Plot.to_svg(plot)

        conn
        |> put_resp_header("content-type", "image/svg+xml")
        |> send_resp(200, svg)

      {:error, _reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Unable to fetch the forecast"})
    end
  end

  def show(conn, _params) do
    latitude = "35.7"
    longitude = "139.7"

    show(conn, %{"latitude" => latitude, "longitude" => longitude})
  end

  defp round_to_one_decimal(number_string) do
    number_string
    |> Float.parse()
    |> elem(0)
    |> Float.round(1)
    |> to_string()
  end
end
