defmodule MessageQueueWeb.Router do
  use MessageQueueWeb, :router

  get "/receive-message", MessageQueueWeb.MessageController, :receive_message
end
