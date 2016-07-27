defmodule ProjectEulixir.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :project_eulixir,
     description: "An Elixir project framework for solving [Project Euler](https://projecteuler.net/) problems.",
     version: @version,
     elixir: "~> 1.3",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
