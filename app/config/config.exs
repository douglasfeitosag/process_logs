# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :brod,
       clients: [
         kafka_client: [
           endpoints: [kafka: 9092],
           auto_start_producers: true,
           # The following :ssl and :sasl configs are not
           # required when running kafka locally unauthenticated
           ssl: true,
           sasl: {
             :plain,
             System.get_env("KAFKA_CLUSTER_API_KEY"),
             System.get_env("KAFKA_CLUSTER_API_SECRET")
           }
         ]
       ]

config :app, App.ElasticsearchCluster,
  url: "http://elasticsearch:9200",
  username: System.get_env("ELASTIC_PASSWORD"),
  password: System.get_env("ELASTIC_USERNAME"),
  json_library: Jason,
  api: Elasticsearch.API.HTTP

config :app, App.ElasticSearchClient.Log,
  url:
    "http://#{System.get_env("ELASTIC_USERNAME")}:#{System.get_env("ELASTIC_PASSWORD")}@elasticsearch:9200",
  index: System.get_env("ELASTIC_INDEX_NAME")

config :app,
  ecto_repos: [App.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "elixir_app", port: 4000],
  check_origin: ["//elixir_app", "//localhost", "//127.0.0.1"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: AppWeb.ErrorHTML, json: AppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "PgkMp6j2"],
  http: [ip: {0, 0, 0, 0}, port: 4000],
  debug_errors: true

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :app, App.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  app: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  app: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :app, App.InfluxDB,
  auth: [method: :token, token: System.get_env("INFLUXDB_TOKEN") || ""],
  org: System.get_env("INFLUXDB_ORG") || "",
  bucket: System.get_env("INFLUXDB_BUCKET") || "",
  host: System.get_env("INFLUXDB_HOST") || ""

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
