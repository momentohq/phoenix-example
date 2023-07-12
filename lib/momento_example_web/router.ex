defmodule MomentoExampleWeb.Router do
  use Phoenix.Router

  scope "/", MomentoExampleWeb do
    get "/", HomeController, :show
  end
end
