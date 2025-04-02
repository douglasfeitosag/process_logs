defmodule App.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :app

  @impl true
  def init(config) do
    {:ok, config}
  end
end
