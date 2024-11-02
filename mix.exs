defmodule AdventOfCode do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "1.0.0",
      deps: deps()
    ]
  end

  defp deps do
    [
      {:dialyxir, ">= 1.4.4", only: [:dev], runtime: false},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end
end
