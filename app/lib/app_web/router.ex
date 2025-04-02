defmodule AppWeb.Router do
  use AppWeb, :router

  import Plug.BasicAuth

  @config Application.get_env(:app, __MODULE__)
  @username @config[:username] || "admin"
  @password @config[:password] || "admin"

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug :basic_auth,
      username: @username,
      password: @password
  end

  scope "/", AppWeb do
    pipe_through :api

    get "/", PageController, :home
  end

  scope "/console", AppWeb do
    pipe_through [:browser, :protected]

    import Phoenix.LiveDashboard.Router

    live_dashboard "/dashboard", metrics: AppWeb.Telemetry
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
