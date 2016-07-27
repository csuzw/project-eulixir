defmodule Definitions do
  
  @typedoc """
  Map that defines a problem
  """
  @type problem :: %{id: pos_integer, name: String.t, solution: String.t, description: String.t, resources: list(String.t)}

  @doc """
  Load problem definitions from a file
  """
  @spec from_file(String.t) :: list(problem)
  def from_file(path) do
    path |> Code.eval_file |> elem(0) # FUTURE file format will most likely change to non-evaluatable form
  end
end