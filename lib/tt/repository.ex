defmodule TT.Repository do
  @repository_path Path.expand("~/.time_tracker")

  def load(initial_state) do
    case File.read(@repository_path) do
      {:ok, binary} ->
        :erlang.binary_to_term(binary)

      {:error, :enoent} ->
        # File does not exist yet. We create a new one with the initial state.
        File.write!(@repository_path, :erlang.term_to_binary(initial_state))
        initial_state

      _ ->
        IO.puts("Unexpected error while trying to read the database.")
        exit({:shutdown, 1})
    end
  end

  def save!(state) do
    File.write!(@repository_path, :erlang.term_to_binary(state))
  end
end
