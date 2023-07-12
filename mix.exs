defmodule MomentoExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :momento_example,
      version: "0.1.0",
      deps: [
        {:jason, "~> 1.2"},
        {:phoenix, "~> 1.7.6"},
        {:plug_cowboy, "~> 2.5"},
        {:gomomento, "0.5.0"},
        {:httpoison, "~> 2.0"},
        {:contex, "~> 0.5.0"}
      ]
    ]
  end

  def application do
    [
      mod: {MomentoExample.Application, []}
    ]
  end
end
