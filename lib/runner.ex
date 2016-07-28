defmodule Runner do
  import Problems

  @spec run(integer) :: :invalid_id | :not_solved | {:no_solution | :success | :failure, number} | {:error, Exception.t} 
  def run(id) do
    try do
      check_solution(id)
    rescue
      e in _ -> {:error, e}
    end
  end

  for problem <- problems do
    module = Module.concat([get_problem_module_name(problem)])

    defp check_solution(unquote(problem.id)), do: unquote(module).solution |> check_solution(unquote(problem.solution))
  end

  defp check_solution(_), do: :invalid_id
  defp check_solution(:no_solution, _), do: :not_solved
  defp check_solution(actual, :no_solution), do: {:no_solution, actual}
  defp check_solution(actual, expected) do
    actual_md5 = actual |> Converters.to_md5
    if actual_md5 === expected do
      {:success, actual}
    else
      {:failure, actual}
    end
  end
end