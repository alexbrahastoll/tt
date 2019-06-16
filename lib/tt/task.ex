alias TT.Repository, as: Repository
import Calendar.Strftime

defmodule TT.Task do
  def tasks do
    Repository.load(initial_state())
  end

  def track(name) do
    if name != tasks()[:current] do
      stop_current()
      add_task(name)
    end
  end

  def stop_current do
    stop(tasks()[:current])
  end

  def stop(name) when name === nil do
    :ignored_attempt_to_stop_nil
  end

  def stop(name) do
    update_in(tasks()[:tasks][name][:sessions], fn sessions ->
      List.replace_at(sessions, -1, %{List.last(sessions) | end: now_unix()})
    end)
    |> (fn tasks_being_edited -> put_in(tasks_being_edited[:current], nil) end).()
    |> Repository.save!()
  end

  def print_tasks(device \\ :stdio, curr_tasks \\ tasks()) do
    if Map.keys(curr_tasks[:tasks]) |> length === 0 do
      IO.puts(device, "There are no tasks being tracked so far.")
    else
      IO.write("Tasks\n\n")

      Enum.each(curr_tasks[:tasks], fn {name, task} ->
        IO.puts("Task: #{name}")
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
    # %{tasks: %{name => %{sessions: [%{start: now, end: nil}]}}}
    %{tasks: %{}}
  end

  defp add_task(name) do
    updated_tasks =
      case tasks()[:tasks][name] do
        nil ->
          put_in(tasks()[:tasks][name], %{sessions: [%{start: now_unix(), end: nil}]})

        _task ->
          update_in(tasks()[:tasks][name][:sessions], fn sessions ->
            sessions ++ [%{start: now_unix(), end: nil}]
          end)
      end

    updated_tasks = put_in(updated_tasks[:current], name)

    Repository.save!(updated_tasks)
  end

  defp now_unix do
    {_, now} = DateTime.now("Etc/UTC")
    Calendar.DateTime.Format.unix(now)
  end
end
