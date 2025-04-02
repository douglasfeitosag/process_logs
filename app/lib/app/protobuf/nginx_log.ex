defmodule App.Protobuf.NginxLog do
  use Protobuf, syntax: :proto2

  field :time_iso8601, 1, type: :string, required: true
  field :remote_addr, 2, type: :string, required: true
  field :request, 3, type: :string, required: true
  field :status, 4, type: :string, required: true
  field :body_bytes_sent, 5, type: :string, required: true
  field :request_time, 6, type: :string, required: true
  field :http_referer, 7, type: :string, required: true
  field :http_user_agent, 8, type: :string, required: true
  field :request_body, 9, type: :string, required: true
  field :host, 10, type: :string, required: true
  field :content_type, 11, type: :string, required: true
  field :content_length, 12, type: :string, required: true
  field :response_time, 13, type: :string, required: true
end
