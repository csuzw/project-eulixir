defmodule Converters do

  @doc """
  Converts a string to snake case

  ## Examples

    iex> Converters.to_snake_case("HelloWorld")
    "hello_world"

    iex> Converters.to_snake_case("A-12__b 34")
    "a_12_b_34"

  """
  @spec to_snake_case(String.t) :: String.t
  def to_snake_case(val) do
    val 
    |> to_fragments
    |> Enum.map(&String.downcase(&1))
    |> Enum.join("_")
  end

  @doc """
  Converts a string to pascal case

  ## Examples

    iex> Converters.to_pascal_case("hello_world")
    "HelloWorld"

    iex> Converters.to_pascal_case("a-12__b 34")
    "A12B34"

  """
  @spec to_pascal_case(String.t) :: String.t
  def to_pascal_case(val) do
    val
    |> to_fragments
    |> Enum.map(&String.capitalize(&1))
    |> List.to_string
  end

  @doc """
  Converts an integer to a fixed length string

  ## Examples

    iex> Converters.to_fixed_length_string(123, 6)
    "000123"

    iex> Converters.to_fixed_length_string(123456, 3)
    "456"

  """
  @spec to_fixed_length_string(non_neg_integer, pos_integer) :: String.t
  def to_fixed_length_string(val, length) do 
    val_as_string = val |> Integer.to_string
    length_difference = length - String.length(val_as_string)
    
    cond do
      length_difference > 0 -> String.duplicate("0", length_difference) <> val_as_string
      length_difference < 0 -> val_as_string |> String.slice(-length, length)
      true -> val_as_string
    end
  end

  @doc """
  Converts value to an MD5 hash

  ## Examples

    iex> Converters.to_md5(233168)
    "e1edf9d1967ca96767dcc2b2d6df69f4"
    
  """
  @spec to_md5(any) :: String.t
  def to_md5(val), do: :crypto.hash(:md5, to_string(val)) |> Base.encode16 |> String.downcase

  @spec to_fragments(String.t) :: list(String.t)
  defp to_fragments(val), do: ~r/[A-Za-z1-9][a-z1-9]*/ |> Regex.scan(val, capture: :first) |> List.flatten
end