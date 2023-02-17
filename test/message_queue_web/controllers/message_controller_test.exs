defmodule MessageQueueWeb.MessageControllerTest do
  use MessageQueueWeb.ConnCase

  describe "Get /api/receive_message" do
    test "returns 200" do
      conn =
        get(build_conn(), "/receive-message", %{
          "queue" => "my_queue",
          "message" => "Hello, Prokeep!"
        })

      assert conn.status == 200

      conn =
        get(build_conn(), "/receive-message", %{
          "queue" => "my_queue,second_queue",
          "message" => "Hello, Prokeep!",
          "broadcast" => "true"
        })

      assert conn.status == 200
    end

    test "adds a message" do
      {:ok, pid} = MessageQueue.start_link("queue_name")

      MessageQueue.add_message("queue_name", "Hello Again")

      queue = :sys.get_state(pid)

      assert queue.messages == ["Hello Again"]
    end

    test "processing a message removes it from a queue" do
      {:ok, pid} = MessageQueue.start_link("queue_name")

      MessageQueue.add_message("queue_name", "Hello Again")
      :timer.sleep(1000)
      MessageQueue.process_message("queue_name")

      queue = :sys.get_state(pid)

      assert queue.messages == []
    end
  end
end
