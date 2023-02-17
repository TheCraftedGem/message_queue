defmodule MessageQueueTest do
  use ExUnit.Case, async: true

  @start_time :os.system_time(:millisecond)

  test "processes only one message per second" do
    queue = "queue_name"
    messages = ["message1", "message2", "message3"]
    {:ok, pid} = MessageQueue.start_link(queue)

    MessageQueue.add_message("queue_name", "Hello Again1")
    MessageQueue.add_message("queue_name", "Hello Again2")
    MessageQueue.add_message("queue_name", "Hello Again3")

    MessageQueue.process_message("queue_name")
    :timer.sleep(1000)
    MessageQueue.process_message("queue_name")
    MessageQueue.process_message("queue_name")

    queue = :sys.get_state(pid)

    assert queue.messages |> length() == 2
  end
end
