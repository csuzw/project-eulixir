defmodule Mix.Tasks.ProjectEulixir.Generate do
  use Mix.Task
  import Problems

  @shortdoc "Generate problem modules"

  def run(_) do
    # FUTURE consider processing asynchronously
    for problem <- problems,
        path = get_problem_file_path(problem),
        !File.exists?(path) do
      write_to_file(path, get_problem_module_content(problem)) # FUTURE consider reducing to :ok/:error to be less side effecty?
    end
  end

  @spec write_to_file(String.t, String.t) :: :ok | {:error, String.t}
  defp write_to_file(path, content) do
    # FUTURE parameterize overwrite method
    result = File.write(path, content)
    case result do
      :ok              -> IO.puts("SUCCESS [#{path}]")
      {:error, reason} -> IO.puts("FAILURE [#{path}]: #{reason}")
    end
    result
  end
end