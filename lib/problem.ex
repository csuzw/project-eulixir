defmodule Problem do
  @callback get_solution() :: number | :no_solution
end