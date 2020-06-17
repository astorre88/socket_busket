defmodule SocketBusket.Pipeline.Worker do
  def start_link(item) do
    Task.start_link(fn ->
      SocketBusket.Statix.measure("pipeline.worker.process_time", fn ->
        process(item)
      end)
    end)
  end

  defp process(%{item: %{data: data, user_id: user_id}, enqueued_at: unix_ms}) do
    SocketBusketWeb.Endpoint.broadcast!("user:#{user_id}", "push_timed", %{
      data: data,
      at: unix_ms
    })
  end

  defp process(%{item: %{data: data, user_id: user_id}}) do
    Process.sleep(1000)
    SocketBusketWeb.Endpoint.broadcast!("user:#{user_id}", "push", data)
  end
end
