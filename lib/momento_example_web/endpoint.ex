defmodule MomentoExampleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :momento_example

  plug Plug.Parsers,
       parsers: [:urlencoded, :multipart, :json],
       pass: ["*/*"],
       json_decoder: Phoenix.json_library()

  plug(MomentoExampleWeb.Router)
end
