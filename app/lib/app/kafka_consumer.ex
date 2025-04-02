defmodule App.KafkaConsumer do
  @behaviour :brod_group_subscriber_v2

  def start_link(_args) do
    config = %{
      client: :kafka_client,
      group_id: "elixir_consumer_group",
      topics: ["my_topic"],
      cb_module: __MODULE__,
      consumer_config: [{:begin_offset, :earliest}],
      init_data: [],
      message_type: :message,
      group_config: [
        offset_commit_policy: :commit_to_kafka_v2,
        offset_commit_interval_seconds: 5
      ]
    }

    :brod_group_subscriber_v2.start_link(config)
  end

  @impl :brod_group_subscriber_v2
  def init(_group_id, _init_data), do: {:ok, %{}}

  @impl :brod_group_subscriber_v2
  def handle_message(message, state) do
    # Processa a mensagem recebida
    IO.inspect(message, label: "Mensagem recebida")

    # Envia a mensagem para o GenStage Producer
    GenStage.cast(App.KafkaProducer, {:new_message, message})

    {:ok, :commit, state}
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
