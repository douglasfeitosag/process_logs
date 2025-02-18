defmodule App.Telemetry do
  use Supervisor
  alias Telemetry.Metrics

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    metrics = [
      Metrics.counter("http.request.count"),
      Metrics.summary("http.request.duration", unit: {:native, :millisecond}),
      Metrics.last_value("vm.memory.total")
    ]

    children = [
      {TelemetryMetricsPrometheus, metrics: metrics}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
