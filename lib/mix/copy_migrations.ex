defmodule Mix.Tasks.Rauversion.CopyMigrations do
  use Mix.Task

  import Macro, only: [camelize: 1, underscore: 1]
  import Mix.Generator
  import Mix.Ecto, except: [migrations_path: 1]

  @shortdoc "Generates migrations for the extension"

  @current_path File.cwd!

  @doc false
  @dialyzer {:no_return, run: 1}

  def run(args) do
    repo = List.first(parse_repo(args))
    path = args[:path] || "priv/repo/migrations"
    source_path = Path.expand("priv/repo/migrations", @current_path)
    dest_path = Path.expand(path |> IO.inspect, File.cwd!)

    if IO.gets("Will copy the following migrations from #{source_path} to #{dest_path}: \n#{inspect File.ls!(source_path)}\n\nType y to confirm: ") == "y\n" do

      File.cp_r(source_path, dest_path, on_conflict: fn source, destination ->
        IO.gets("Overwriting #{destination} by #{source}. Type y to confirm. ") == "y\n"
      end)

      if Mix.shell().yes?("Do you want to run these migrations on #{repo}?") do
        Mix.Task.run("ecto.migrate", [repo])
      end
    end

  end

end
