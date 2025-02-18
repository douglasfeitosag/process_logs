defmodule App.Metrics do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/metrics" do
    send_resp(conn, 200, TelemetryMetricsPrometheus.Core.scrape())
  end
end