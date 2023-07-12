import Config

config :momento_example, MomentoExampleWeb.Endpoint, []

config :phoenix, :json_library, Jason

config :logger, :console, format: "$time [$level] $message\n"

config :momento_example, :weather_cache_name, "weather-cache"

import_config "#{Mix.env()}.exs"
