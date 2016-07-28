defmodule Mix.Tasks.ProjectEulixir.Solve do
  use Mix.Task

  @shortdoc "Solve specified problem"
  
  # FUTURE colorize text
  def run([]), do:                 put_message("No problem ID provided")
  def run([id | _]) do   
    case id |> Integer.parse do
      {int, _}                  -> run(int)
      :error                    -> put_message(id, "Invalid problem ID")
      _                         -> put_message(id, "Unexpected result")
    end
  end
  def run(id) when is_integer(id) do
     case id |> Runner.run do
      :not_solved               -> put_message(id, "Unsolved")
      :invalid_id               -> put_message(id, "Invalid problem ID")
      {:success, solution}      -> put_message(id, "Success (#{solution})")
      {:failure, solution}      -> put_message(id, "Failure (#{solution})")
      {:no_solution, solution}  -> put_message(id, "No solution (#{solution})")
      {:error, e}               -> put_message(id, "Error [#{e.message}]")
      _                         -> put_message(id, "Unexpected result")
    end   
  end

  defp put_message(message),     do: IO.puts(message) 
  defp put_message(id, message), do: IO.puts("Problem #{id}: #{message}") 
end