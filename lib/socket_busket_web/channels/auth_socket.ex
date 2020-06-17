defmodule SocketBusketWeb.AuthSocket do
  use Phoenix.Socket
  require Logger

  channel "ping", SocketBusketWeb.PingChannel
  channel "tracked", SocketBusketWeb.TrackedChannel
  channel "user:*", SocketBusketWeb.AuthChannel
  channel "recurring", SocketBusketWeb.RecurringChannel

  def connect(%{"token" => token}, socket) do
    case verify(socket, token) do
      {:ok, user_id} ->
        socket = assign(socket, :user_id, user_id)
        {:ok, socket}

      {:error, err} ->
        Logger.error("#{__MODULE__} connect error #{inspect(err)}")
        :error
    end
  end

  def connect(_, _socket) do
    Logger.error("#{__MODULE__} connect error missing params")
    :error
  end

  def id(%{assigns: %{user_id: user_id}}), do: "auth_socket:#{user_id}"

  @one_day 86400
  defp verify(socket, token) do
    # Better to use joken library!
    Phoenix.Token.verify(socket, "salt identifier", token, max_age: @one_day)
  end
end
