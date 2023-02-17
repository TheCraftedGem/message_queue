defmodule MessageQueueWeb.MessageController do
  use MessageQueueWeb, :controller

  def receive_message(conn, %{"queue" => queue_names, "message" => message, "broadcast" => "true"}) do
    format_queues(queue_names)
    |> Enum.each(fn queue_name ->
      children =
        Supervisor.which_children(MessageQueue.Supervisor)
        |> Enum.filter(fn {name, _, _, _} -> name == queue_name end)

      case children do
        [] ->
          MessageQueue.create_new_queue(queue_name, message)

        [{_, _pid, _, _}] ->
          MessageQueue.add_message_to_queue(queue_name, message)
      end
    end)

    conn |> send_resp(200, "OK")
  end

  def receive_message(conn, %{"queue" => queue_name, "message" => message}) do
    children =
      Supervisor.which_children(MessageQueue.Supervisor)
      |> Enum.filter(fn {name, _, _, _} -> name == queue_name end)

    case children do
      [] ->
        MessageQueue.create_new_queue(queue_name, message)
        conn |> send_resp(200, "OK")

      [{_, _pid, _, _}] ->
        MessageQueue.add_message_to_queue(queue_name, message)
        conn |> send_resp(200, "OK")
    end
  end

  def format_queues(queue_names) do
    String.split(queue_names, ",")
  end
end
