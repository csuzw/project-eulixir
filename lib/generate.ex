defmodule Mix.Tasks.ProjectEulixir.Generate do
  use Mix.Task
  import Converters

  @shortdoc "Generate problem modules"

  @problem_definition_path "data/problem_definition.txt"

  @typep module_definition :: %{path: String.t, content: String.t}

  def run(_) do
    # FUTURE consider processing asynchronously
    @problem_definition_path
    |> Definitions.from_file
    |> Enum.map(&to_module(&1))
    |> Enum.map(&to_file(&1)) # FUTURE consider reducing to :ok/:error to be less side effecty?
  end

  @spec to_module(Definitions.problem) :: module_definition
  defp to_module(problem) do
    path = problem |> get_module_path
    content = problem |> get_module_content

    %{:path => path, :content => content}
  end

  @spec to_file(module_definition) :: any
  defp to_file(module) do
    # FUTURE if File.exists?(path) ...
    # FUTURE parameterize overwrite method
    case File.write(module.path, module.content) do
      :ok              -> IO.puts("SUCCESS [#{module.path}]")
      {:error, reason} -> IO.puts("FAILURE [#{module.path}]: #{reason}")
    end
  end

  @spec get_module_path(Definitions.problem) :: String.t
  defp get_module_path(problem) do
    id = problem.id |> to_fixed_length_string(3)
    name = problem.name |> to_snake_case

    "lib/problems/#{id}_#{name}.ex"
  end

  @spec get_module_content(Definitions.problem) :: String.t
  defp get_module_content(problem) do
    name = problem.name |> to_pascal_case
    description = problem.description
    resources = problem.resources |> to_module_attributes

"defmodule Problems.#{name} do
  @behaviour Problem
  #{resources}   
  @doc \"\"\"
  #{description}
  \"\"\"
  def get_solution() do 
    :no_solution
  end
end"
  end

  @spec to_module_attributes(list(String.t)) :: String.t
  defp to_module_attributes([]), do: ""
  defp to_module_attributes(resources), do: resources |> to_module_attributes("\n")
  @spec to_module_attributes(list(String.t), String.t) :: String.t
  defp to_module_attributes([], acc), do: acc
  defp to_module_attributes([resource | remaining_resources], acc), do: remaining_resources |> to_module_attributes(acc <> (resource |> to_module_attribute))

  @spec to_module_attribute(String.t) :: String.t
  defp to_module_attribute(resource) do
    name = resource |> get_file_name_without_extension |> to_snake_case

    "  @#{name}_path \"#{resource}\"\n"
  end

  @spec get_file_name_without_extension(String.t) :: String.t
  defp get_file_name_without_extension(path), do: path |> Path.basename((path |> Path.extname))
end