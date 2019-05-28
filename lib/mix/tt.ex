defmodule Mix.Tasks.TT do
  use Mix.Task

  def run(argv) do
    TT.CLI.main(argv)
  end
end
