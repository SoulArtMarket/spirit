defmodule SpiritWeb.Router do
  use SpiritWeb, :router

  @max_complexity Application.fetch_env!(:spirit, :max_complexity)

  pipeline :api do
    plug :accepts, ["json"]
    plug SpiritWeb.Environment
    plug SpiritWeb.Auth
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: SpiritWeb.Schema,
      analyze_complexity: true,
      max_complexity: @max_complexity

    forward "/", Absinthe.Plug,
      schema: SpiritWeb.Schema,
      analyze_complexity: true,
      max_complexity: @max_complexity
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: SpiritWeb.Telemetry
    end
  end
end
