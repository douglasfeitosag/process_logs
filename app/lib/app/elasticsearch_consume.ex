defmodule App.ElasticsearchConsumer do
  use GenStage
  alias App.ElasticSearchClient.Log
  alias App.SystemMetrics

  def start_link(_) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:consumer, state}
  end

  def handle_events(events, _from, state) do
    fn_put_document = fn event ->
      formatted_event = Map.from_struct(event)
      Log.insert_log(formatted_event)
    end

    events
    |> Task.async_stream(fn_put_document,
      max_concurrency: SystemMetrics.get_max_concurrency(),
      timeout: 5000
    )
    |> Stream.run()

    {:noreply, [], state}
  end
end
