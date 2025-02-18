local status_codes = {200, 301, 400, 401, 403, 404, 500, 503}
local random_index = math.random(1, #status_codes)
local status = status_codes[random_index]

ngx.status = status
ngx.header["Content-Type"] = "text/plain"
ngx.req.read_body()

local httpc = require("resty.http").new()
local cjson = require "cjson"
local pb = require "pb"
local protoc = require "protoc"

local routing_key = os.getenv("RABBITMQ_ROUTING_KEY")
local rabbit_exchange = os.getenv("RABBITMQ_EXCHANGE")
local rabbit_url = os.getenv("RABBITMQ_URL")
local rabbit_user = os.getenv("RABBITMQ_USER")
local rabbit_pass = os.getenv("RABBITMQ_PASS")
local authorization = 'Basic ' .. ngx.encode_base64(rabbit_user .. ':' .. rabbit_pass)

assert(protoc:load [[
    message NginxLog {
      required string time_iso8601 = 1;
      required string remote_addr = 2;
      required string request = 3;
      required string status = 4;
      required string body_bytes_sent = 5;
      required string request_time = 6;
      required string http_referer = 7;
      required string http_user_agent = 8;
      required string request_body = 9;
      required string host = 10;
      required string content_type = 11;
      required string content_length = 12;
      required string duplicated_time_iso8601 = 13;
    }
]])

local decoded_body = {
    time_iso8601 = ngx.var.time_iso8601,
    remote_addr = ngx.var.remote_addr,
    method = ngx.var.method,
    request_uri = ngx.var.request_uri,
    status = ngx.var.status,
    body_bytes_sent = ngx.var.body_bytes_sent,
    request_time = ngx.var.request_time,
    http_referer = ngx.var.http_referer,
    http_user_agent = ngx.var.http_user_agent,
    body_data = ngx.var.body_data,
    host = ngx.var.host,
    content_type = ngx.var.content_type,
    content_length = ngx.var.content_length
}

local encode = pb.encode("NginxLog", decoded_body)
local payload = ngx.encode_base64(encode)

local body = {
    properties = { delivery_mode = 2 },
    routing_key = routing_key,
    payload = payload,
    payload_encoding = "string"
}

local res, err = httpc:request_uri(rabbit_url .. "/api/exchanges/%2f/" .. rabbit_exchange .. "/publish", {
    method = "POST",
    body = cjson.encode(body),
    headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = authorization
    }
})

if not res then
    ngx.log(ngx.STDERR, tostring(err))
end

ngx.exit(status)