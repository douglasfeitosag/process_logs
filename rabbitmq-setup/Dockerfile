FROM rabbitmq:3.13-management

USER root

RUN apt-get update && \
    apt-get install -y ruby-full build-essential && \
    rm -rf /var/lib/apt/lists/*

ENV GEM_HOME="/usr/local/bundle"
ENV PATH="$GEM_HOME/bin:$PATH"

COPY docker_entrypoint.sh /docker_entrypoint.sh
COPY rabbitmq_setup.rb /rabbitmq_setup.rb
COPY .erlang.cookie /var/lib/rabbitmq/.erlang.cookie

RUN gem install bundler && gem install bunny httparty

RUN chmod +x /docker_entrypoint.sh
RUN chmod +x /rabbitmq_setup.rb
RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie

USER rabbitmq

ENTRYPOINT ["ruby", "/rabbitmq_setup.rb"]

