defmodule App.ElasticSearchClient.Log do
  alias Elasticsearch.Index

  @config Application.compile_env(:app, __MODULE__)
  @url Keyword.get(@config, :url)
  @index Keyword.get(@config, :index)

  def create_index do
    Index.create(@url, "nginx_logs", %{
      mappings: %{
        properties: %{
          "time_iso8601" => %{type: "date"},
          "remote_addr" => %{type: "ip"},
          "request" => %{type: "text"},
          "status" => %{type: "keyword"},
          "body_bytes_sent" => %{type: "long"},
          "request_time" => %{type: "float"},
          "http_referer" => %{type: "text"},
          "http_user_agent" => %{type: "text"},
          "request_body" => %{type: "text"},
          "host" => %{type: "keyword"},
          "content_type" => %{type: "keyword"},
          "content_length" => %{type: "long"},
          "response_time" => %{type: "float"},
          "timestamp" => %{type: "date"}
        }
      }
    })
  end

  def insert_log(log_data) do
    timestamp = DateTime.utc_now()
    log_data = Map.put(log_data, :timestamp, timestamp)

    case Elasticsearch.put_document(App.ElasticsearchCluster, log_data, @index) do
      {:ok, result} ->
        IO.inspect(result, label: "Resultado da inserção")
        :ok

      {:error, error} ->
        IO.inspect(error, label: "Erro ao inserir log")
        :error
    end
  end
end
