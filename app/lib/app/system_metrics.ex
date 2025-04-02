defmodule App.SystemMetrics do
  @default_concurrency 10

  def get_max_concurrency do
    case :ets.lookup(Finch.Pool, {App.Finch, :pool_size}) do
      [{_, pool_size}] ->
        available = max(1, div(pool_size * 80, 100))
        IO.puts("Using max_concurrency: #{available}")
        available

      _ ->
        IO.puts("Could not retrieve Finch pool size. Using default: #{@default_concurrency}")
        @default_concurrency
    end
  end
end
