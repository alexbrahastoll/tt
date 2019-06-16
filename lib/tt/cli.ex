alias TT.Task, as: Task

defmodule TT.CLI do
  def main(cli_args \\ []) do
    case cli_args do
      [cmd | cmd_args] ->
        case cmd do
          "list" ->
            Task.print_tasks()

          "track" ->
            check_cmd_args(:track, cmd_args)

          "stop" ->
            Task.stop_current()

          "report" ->
            check_cmd_args(:report, cmd_args)

          _ ->
            IO.puts("#{cmd} is not a valid command.")
        end

      [] ->
        Task.print_tasks()
    end
  end

  defp check_cmd_args(cmd, args) do
    case args do
      [_arg] ->
        apply(Task, cmd, args)

      _ ->
        IO.puts("#{cmd} command usage: tt #{cmd} task_name")
    end
  end
end
