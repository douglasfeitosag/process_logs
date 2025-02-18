# Etapa base com Elixir e Node.js para compilar assets
FROM hexpm/elixir:1.18.2-erlang-27.2-debian-bookworm-20250113-slim AS build

# Instalar dependências de sistema
RUN apt-get update && \
    apt-get install -y build-essential inotify-tools git curl && \
    apt-get install -y postgresql-client && \
    apt-get clean

# Instalar Node.js (necessário para compilar assets)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Instalar Tailwind e Esbuild globalmente, se necessário
RUN npm install -g tailwindcss esbuild

# Definir diretório de trabalho dentro do container
WORKDIR /app

# Copiar arquivos de configuração do Elixir e Phoenix para instalar dependências
COPY mix.exs mix.lock ./
COPY config config

# Instalar dependências da aplicação (Hex e Rebar)
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Copiar assets e compilar os arquivos estáticos
COPY priv priv
COPY assets assets
RUN mix assets.setup && mix assets.build

# Copiar o restante da aplicação
COPY lib lib

# Compilar a aplicação Phoenix para ambiente de produção
RUN MIX_ENV=prod mix do compile, phx.digest, release

# Etapa de execução com imagem minimalista do Elixir
FROM hexpm/elixir:1.18.2-erlang-27.2-debian-bookworm-20250113-slim AS release

# Instalar runtime Erlang e criar diretório de trabalho
RUN apt-get update && apt-get install -y libssl-dev postgresql-client && apt-get clean
WORKDIR /app

# Copiar arquivos da etapa de `build` para o runtime
COPY --from=build /app/_build/prod/rel/* ./

# Expor a porta padrão do Phoenix (4000)
EXPOSE 4000

# Definir a entrada padrão do container
CMD ["bin/app", "start"]