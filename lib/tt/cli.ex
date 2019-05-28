alias TT.Task, as: Task

defmodule TT.CLI do
  def main(cli_args \\ []) do
    case cli_args do
      [cmd | cmd_args] ->
        case cmd do
          "list" ->
            Task.print_tasks()

          "track" ->
            case cmd_args do
              [task] ->
                Task.add_task(task)

              _ ->
                IO.puts("#{cmd} command usage: tt #{cmd} task_name")
            end

          _ ->
            IO.puts("#{cmd} is not a valid command.")
        end

      [] ->
        Task.print_tasks()
    end
  end
end