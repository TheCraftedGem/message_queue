# MessageQueue

Instructions:

Build an application that accepts messages via an HTTP endpoint and processes the messages in the order that they are received. The application should be able to handle multiple queues based on a parameter passed into the HTTP endpoint. Each queue should be rate limited to process no more than one message per second.

1. We would like to see usage of Phoenix and Elixir for this task.
2. You should have an HTTP endpoint at the path /receive-message which accepts a GET request with the query string parameters queue (string) and message (string).
3. Your application should accept messages as quickly as they come in and return a 200 status code.
4. Your application should “process” the messages by printing the message text to the terminal, however for each queue, your application should only “process” one message a second, no matter how quickly the messages are submitted to the HTTP endpoint.
5. Bonus points for writing some kind of test that verifies messages are only processed one per second.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

To run your tests run the following command from your terminal. 

  * `mix deps.get`

  
To quickly test this application once your server is running you can run the following curl command from your terminal. Notice the broadcast param is set to true this allows you to send messages to multiple queues, the queues should be comma seperated.

  * `curl "http://localhost:4000/receive-message?queue=queue1,queue2,queue3&message=ProkeepWelcomesYou&broadcast=true"`
  
Your terminal should output a message similar to this. 

  
  <img width="728" alt="Screenshot 2023-02-17 at 4 50 38 PM" src="https://user-images.githubusercontent.com/38091448/219800585-ebbdab5b-c9ab-4de4-9339-7a1e9a1075e0.png">


To process a message for a single queue you can use the following curl command from your terminal.
  * `curl "http://localhost:4000/receive-message?queue=queue1&message=ProkeepWelcomesYou!"`
  
  Your terminal should output a message similar to this. 

<img width="503" alt="Screenshot 2023-02-17 at 4 48 09 PM" src="https://user-images.githubusercontent.com/38091448/219800268-feba31cd-f63a-4092-9b13-744a0cbc0fb9.png">
