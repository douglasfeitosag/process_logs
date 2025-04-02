require 'bunny'
require 'httparty'

RABBITMQ_USER = ENV['RABBITMQ_DEFAULT_USER']
RABBITMQ_PASS = ENV['RABBITMQ_DEFAULT_PASS']
RABBITMQ_HOST = ENV['RABBITMQ_HOST']
RABBITMQ_HTTP_PORT = 15672
RABBITMQ_AMQP_PORT = 5672

RABBITMQ_EXCHANGE = ENV['RABBITMQ_EXCHANGE']
RABBITMQ_QUEUE = ENV['RABBITMQ_STREAM']
RABBITMQ_ROUTING_KEY = ENV['RABBITMQ_ROUTING_KEY']

def wait_for_rabbitmq
  puts "Waiting for RabbitMQ to be available on #{RABBITMQ_HOST}:#{RABBITMQ_HTTP_PORT}..."
  until rabbitmq_ready?
    sleep 3
    puts "Still waiting for RabbitMQ..."
  end
  puts "RabbitMQ is up!"
end

def rabbitmq_ready?
  url = "http://#{RABBITMQ_USER}:#{RABBITMQ_PASS}@#{RABBITMQ_HOST}:#{RABBITMQ_HTTP_PORT}/api/healthchecks/node"
  response = HTTParty.get(url)
  response.code == 200
rescue StandardError
  false
end

def connect_rabbitmq
  Bunny.new(
    host: RABBITMQ_HOST,
    port: RABBITMQ_AMQP_PORT,
    user: RABBITMQ_USER,
    password: RABBITMQ_PASS
  ).tap(&:start)
end

def declare_exchange(channel)
  exchange = channel.exchange(RABBITMQ_EXCHANGE, type: 'direct', durable: true)
  puts "Exchange '#{RABBITMQ_EXCHANGE}' created."
  exchange
end

def declare_stream(channel)
  queue = channel.queue(RABBITMQ_QUEUE, durable: true, arguments: { 'x-queue-type' => 'stream' })
  puts "Stream Queue '#{RABBITMQ_QUEUE}' created."
  queue
end

def declare_binding(exchange, queue)
  queue.bind(exchange, routing_key: RABBITMQ_ROUTING_KEY)
  puts "Binding between '#{RABBITMQ_EXCHANGE}' and '#{RABBITMQ_QUEUE}' with routing key '#{RABBITMQ_ROUTING_KEY}' created."
end

wait_for_rabbitmq

connection = connect_rabbitmq
channel = connection.create_channel

exchange = declare_exchange(channel)
queue = declare_stream(channel)
declare_binding(exchange, queue)

puts "RabbitMQ configuration completed successfully!"
connection.close

while true; end