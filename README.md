# Momento Phoenix Example

A simple example of a way to integrate the Momento Elixir SDK into a phoenix project. The example code is based on
[minimum viable phoenix](https://github.com/pcorey/minimum_viable_phoenix). It contains one endpoint that takes a
latitude and longitude and returns a plot of hourly temperature data for those coordinates. The weather forecast is
powered by Japan Meteorological Agency data from Open Mateo. The data is cached with Momento keyed on the lat/long pair.

## Usage

These instructions assume you have elixir installed and the code checked out.

1. Run `mix deps.get` to install the dependencies.
2. Set the `MOMENTO_AUTH_TOKEN` environment variable to your Momento auth token.
3. Run `mix phx.server` to compile and start the server. It will create a cache 'weather-cache' for storing forecasts.
4. Browse to http://localhost:4000 to hit the endpoint eith Tokyo's lat/long, or provide a lat/long like this:
http://localhost:4000/?latitude=35.7&longitude=139.7

The first call with a new lat/long pair will call through to the Open Mateo API, and subsequent calls will use the
cached data. The cache is set to expire data after one hour.
