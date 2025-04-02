defmodule App.KafkaProducer do
  use GenStage
  require Logger

  alias App.Protobuf.NginxLog

  def start_link(_) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:producer, %{buffer: [], demand: 0}}
  end

  @impl true
  def handle_cast({:new_message, message}, state) do
    decoded_message = decode_message(message)

    if state.demand > 0 do
      {to_send, remaining_buffer} = Enum.split([decoded_message | state.buffer], state.demand)

      {:noreply, to_send,
        %{state | buffer: remaining_buffer, demand: state.demand - length(to_send)}}
    else
      {:noreply, [], %{state | buffer: state.buffer ++ [decoded_message]}}
    end
  end

  @impl true
  def handle_demand(demand, state) do
    {to_send, remaining_buffer} = Enum.split(state.buffer, demand)

    {:noreply, to_send,
      %{state | buffer: remaining_buffer, demand: state.demand + demand - length(to_send)}}
  end

  defp decode_message(message) do
    message
    |> Base.decode64!()
    |> NginxLog.decode()
  end
end
