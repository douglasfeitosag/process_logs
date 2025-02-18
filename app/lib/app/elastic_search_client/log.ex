defmodule App.ElasticSearchClient.Log do
  alias Elasticsearch.Index
  alias Elasticsearch.Document

  @config Application.get_env(:my_app, App.ElasticSearchClient.Log, %{})
  @url Map.get(@config, :url)
  @index Map.get(@config, :index)

  def create_index do
    Index.create(@url, @index, %{
      mappings: %{
        properties: %{
          "timestamp" => %{type: "date"},
          "ip" => %{type: "ip"},
          "request" => %{type: "text"},
          "status_code" => %{type: "integer"},
          "body_bytes_sent" => %{type: "long"},
          "response_time" => %{type: "float"},
          "http_referer" => %{type: "text"},
          "user_agent" => %{type: "text"},
          "request_body" => %{type: "text"},
          "host" => %{type: "keyword"},
          "content_type" => %{type: "keyword"},
          "content_length" => %{type: "long"}
        }
      }
    })
  end

  def insert_log(log_data) do
    Document.index(@url, @index, log_data)
  end
end
