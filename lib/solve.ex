defmodule Mix.Tasks.ProjectEulixir.Solve do
  use Mix.Task

  @shortdoc "Solve specified problem"
  
  def run([]), do:                 put_message("No problem ID provided", IO.ANSI.red)
  def run([id | _]) do   
    case id |> Integer.parse do
      {int, _}                  -> run(int)
      :error                    -> put_message("Problem #{id}: Invalid problem ID", IO.ANSI.red)
      _                         -> put_message("Problem #{id}: Unexpected result", IO.ANSI.red)
    end
  end
  def run(id) when is_integer(id) do
     case id |> Runner.run do
      :not_solved               -> put_message("Problem #{id}: Unsolved")
      :invalid_id               -> put_message("Problem #{id}: Invalid problem ID", IO.ANSI.red)
      {:success, solution}      -> put_message("Problem #{id}: Success (#{solution})", IO.ANSI.green)
      {:no_solution, solution}  -> put_message("Problem #{id}: No solution (#{solution})", IO.ANSI.yellow)
      {:failure, solution}      -> put_message("Problem #{id}: Failure (#{solution})", IO.ANSI.red)
      {:error, e}               -> put_message("Problem #{id}: Error [#{e.message}]", IO.ANSI.red)
      _                         -> put_message("Problem #{id}: Unexpected result", IO.ANSI.red)
    end   
  end

  defp put_message(message), do: IO.puts(message)
  defp put_message(message, color), do: IO.puts([color, message, IO.ANSI.reset]) 
end