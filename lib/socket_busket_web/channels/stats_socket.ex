defmodule SocketBusketWeb.StatsSocket do
  use Phoenix.Socket

  channel "*", SocketBusketWeb.StatsChannel

  def connect(_params, socket, _connect_info) do
    SocketBusket.Statix.increment("socket_connect", 1,
      tags: ["status:success", "socket:StatsSocket"]
    )

    {:ok, socket}
  end

  def id(_socket), do: nil
end
