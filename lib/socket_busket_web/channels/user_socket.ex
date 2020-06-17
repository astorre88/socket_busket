defmodule SocketBusketWeb.UserSocket do
  use Phoenix.Socket

  channel "ping", SocketBusketWeb.PingChannel
  channel "ping:*", SocketBusketWeb.PingChannel
  channel "wild:*", SocketBusketWeb.WildcardChannel
  channel "dupe", SocketBusketWeb.DedupeChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
