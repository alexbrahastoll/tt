defmodule TT.MixProject do
  use Mix.Project

  def project do
    [
      app: :tt,
      version: "0.1.0",
      elixir: "~> 1.8",
      escript: [main_module: TT.CLI],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      applications: [:calendar]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tzdata, "~> 0.1.201603"},
      {:calendar, "~> 0.17.6"}
    ]
  end
end
