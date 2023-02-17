defmodule MessageQueue do
  use GenServer

  def start_link(queue) do
    GenServer.start_link(__MODULE__, queue, name: via_tuple(queue))
  end

  def init(queue_name) do
    {:ok, %{queue_name: queue_name, messages: [], last_processed: :os.system_time(:millisecond)}}
  end

  def via_tuple(queue_name) do
    {:global, {__MODULE__, queue_name}}
  end

  def add_message(queue, message) do
    GenServer.cast(via_tuple(queue), {:add_message, message})
  end

  def process_message(queue) do
    GenServer.call(via_tuple(queue), :process_message)
  end

  def handle_cast({:add_message, message}, state) do
    {:noreply,
     %{
       state
       | messages: state.messages ++ [message],
         last_processed: :os.system_time(:millisecond)
     }}
  end

  def handle_info(:process_message, state) do
    [message | rest_of_queue] = state.messages
    IO.puts("Processing message: #{message} from queue #{state.queue_name}")
    new_state = %{state | messages: rest_of_queue, last_processed: :os.system_time(:millisecond)}
    {:noreply, new_state}
  end

  def handle_call(:process_message, _from, state) do
    {rate_limited, now} = rate_limit(state)

    if rate_limited do
      {last_processed, now} = {state.last_processed, :os.system_time(:millisecond)}
      Process.send_after(self(), :process_message, 1000 - (now - last_processed))
      {:reply, :ok, state}
    else
      [message | rest_of_queue] = state.messages
      IO.puts("Processing message: #{message} from queue #{state.queue_name}")
      new_state = %{state | messages: rest_of_queue, last_processed: now}
      {:reply, :ok, new_state}
    end
  end

  def create_new_queue(queue_name, message) do
    start_link(queue_name)
    add_message(queue_name, message)
    process_message(queue_name)
  end

  def add_message_to_queue(queue_name, message) do
    add_message(queue_name, message)
    process_message(queue_name)
  end

  defp rate_limit(state) do
    {last_processed, now} = {state.last_processed, :os.system_time(:millisecond)}
    rate_limited = now - last_processed < 1000

    {rate_limited, now}
  end
end
