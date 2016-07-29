defmodule Problems do
  import Converters
  
  @typedoc """
  Map that defines a problem
  """
  @type problem :: %{id: pos_integer, name: String.t, solution: String.t, description: String.t, resources: list(String.t)}

  @external_resource problems_resource = "data/problem_definition.txt"
  @problems problems_resource |> Code.eval_file |> elem(0) # FUTURE file format will most likely change to non-evaluatable form

  @doc """
  Get problems from resource
  """
  @spec problems() :: list(problem)
  def problems do
    @problems
  end

  @spec get_problem_module(problem) :: String.t
  def get_problem_module(problem) do
    problem 
    |> get_problem_module_name 
    |> List.wrap 
    |> Module.concat 
    |> Code.ensure_compiled
    |> handle_ensure_compiled_result(problem)
  end

  @doc """
  Get file name for given problem

  ## Examples

    iex> Problems.get_problem_file_name(%{id: 1, name: "Multiples of 3 and 5", solution: "", description: "", resources: []})
    "001_multiples_of_3_and_5.ex"

  """
  @spec get_problem_file_name(problem) :: String.t
  def get_problem_file_name(problem) do
    id = problem.id |> to_fixed_length_string(3)
    name = problem.name |> to_snake_case

    "#{id}_#{name}.ex"
  end

  @doc """
  Get file path for given problem

  ## Examples

    iex> Problems.get_problem_file_path(%{id: 1, name: "Multiples of 3 and 5", solution: "", description: "", resources: []})
    "./lib/problems/001_multiples_of_3_and_5.ex"

  """
  @spec get_problem_file_path(problem) :: String.t
  def get_problem_file_path(problem) do
    file_name = problem |> get_problem_file_name

    "./lib/problems/#{file_name}" 
  end

  @doc """
  Get module name for given problem

  ## Examples

    iex> Problems.get_problem_module_name(%{id: 1, name: "Multiples of 3 and 5", solution: "", description: "", resources: []})
    "Problems.MultiplesOf3And5"

  """
  @spec get_problem_module_name(problem) :: String.t
  def get_problem_module_name(problem) do
    module_name = problem.name |> to_pascal_case

    "Problems.#{module_name}"
  end

  defp handle_ensure_compiled_result({:module, module}, _), do: module
  defp handle_ensure_compiled_result(_, problem) do
    problem
    |> create_problem_module
    |> require_problem_module
  end

  defp require_problem_module({:error, reason, _}), do: raise(CompileError, reason)
  defp require_problem_module({:ok, path}) do
    {module, _} = path |> Code.load_file |> List.first
    module
  end 

  @spec create_problem_module(problem) :: {:ok, String.t} | {:error, String.t, String.t}
  defp create_problem_module(problem) do
    path = problem |> get_problem_file_path
    content = problem |> get_problem_module_content

    create_problem_module(path, content)
  end

  @spec create_problem_module(String.t, String.t) :: {:ok, String.t} | {:error, String.t, String.t}
  defp create_problem_module(path, content) do
    if !File.exists?(path) do
      File.write(path, content) |> handle_write_file_result(path)
    else
      {:ok, path}
    end
  end 

  defp handle_write_file_result({:error, reason}, path) do
    IO.puts("Failed to create '#{path}': #{reason}")
    {:error, reason, path}
  end
  defp handle_write_file_result(:ok, path) do
    IO.puts("Successfully created '#{path}'")
    {:ok, path}
  end

  @spec get_problem_module_content(problem) :: String.t
  defp get_problem_module_content(problem) do
    name = problem |> get_problem_module_name
    description = problem.description
    resources = problem.resources |> to_module_attributes

"defmodule #{name} do
  @behaviour Problem
  #{resources}   
  @doc \"\"\"
  #{description}
  \"\"\"
  def solution do 
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
    name = resource |> get_resource_attribute_name

    "  @#{name}_path \"#{resource}\"\n"
  end

  @spec get_resource_attribute_name(String.t) :: String.t
  defp get_resource_attribute_name(resource), do: resource |> get_file_name_without_extension |> to_snake_case

  @spec get_file_name_without_extension(String.t) :: String.t
  defp get_file_name_without_extension(path), do: path |> Path.basename((path |> Path.extname))
end