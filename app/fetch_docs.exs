defmodule DotenvLoader do
  def load_env_file(file \\ ".env") do
    case File.read(file) do
      {:ok, contents} ->
        Mix.shell().info(contents)
        IO.puts(contents)

        contents
        |> String.split("\n", trim: true)
        |> Enum.each(fn line ->
          [key, value] = String.split(line, "=", parts: 2)
          System.put_env(String.trim(key), String.trim(value))
        end)

      {:error, reason} ->
        IO.puts("Não foi possível carregar o arquivo #{file}: #{reason}")
    end
  end
end

DotenvLoader.load_env_file()

defmodule FetchDocs do
  def fetch_all_docs do
    Mix.Project.deps_paths()
    |> Map.keys()
    |> Enum.each(fn dependency ->
      Mix.shell().info("Fetching docs for: #{dependency}")
      Mix.Task.run("hex.docs", ["fetch", to_string(dependency)])
    end)
  end
end

# Mix.shell().info(Mix.Project.deps_paths())

# FetchDocs.fetch_all_docs()
