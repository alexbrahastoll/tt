alias TT.Repository, as: Repository
import Calendar.Strftime

defmodule TT.Task do
  def tasks do
    Repository.load(initial_state())
  end

  def add_task(name) do
    {_, now} = DateTime.now("Etc/UTC")
    now_unix = Calendar.DateTime.Format.unix(now)

    # %{tasks: [%{name: task, sessions: [%{start: now, end: nil}]}]}
    new_tasks = %{
      tasks: tasks()[:tasks] ++ [%{name: name, sessions: [%{start: now_unix, end: nil}]}]
    }

    Repository.save!(new_tasks)
  end

  def print_tasks(device \\ :stdio, curr_tasks \\ tasks()) do
    if Kernel.length(curr_tasks[:tasks]) === 0 do
      IO.puts(device, "There are no tasks being tracked so far.")
    else
      IO.write("Tasks\n\n")

      Enum.each(curr_tasks[:tasks], fn task ->
        IO.puts("Task: #{task[:name]}")
        IO.puts("Sessions:")

        Enum.each(task[:sessions], fn session ->
          IO.puts("Start: #{print_start(session[:start])}")
          IO.puts("  End: #{print_end(session[:end])}")
        end)
      end)
    end
  end

  def print_start(session_start) do
    print_datetime(session_start)
  end

  def print_end(session_end) when session_end === nil do
    "(in progress)"
  end

  def print_end(session_end) do
    print_datetime(session_end)
  end

  def print_datetime(unix_timestamp) do
    Calendar.DateTime.Parse.unix!(unix_timestamp)
    |> Calendar.DateTime.shift_zone!("America/Sao_Paulo")
    |> strftime!("%d/%m/%Y %H:%M:%S")
  end

  defp initial_state do
    # Tasks are to be stored by using the following data structure.
    # %{tasks: [%{name: task, sessions: [%{start: now, end: nil}]}]}
    %{tasks: []}
  end
end
