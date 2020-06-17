defmodule SocketBusket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias SocketBusket.Pipeline.Producer
  alias SocketBusket.Pipeline.ConsumerSupervisor, as: Consumer

  def start(_type, _args) do
    :ok = SocketBusket.Statix.connect()
    Vapor.load!([%Vapor.Provider.Dotenv{}])
    load_system_env()
    # List all child processes to be supervised
    children = [
      {Producer, name: Producer},
      {Consumer, subscribe_to: [{Producer, max_demand: 10, min_demand: 5}]},
      SocketBusketWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SocketBusket.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SocketBusketWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp load_system_env do
    providers = %Vapor.Provider.Env{
      bindings: [
        {:port, "PORT", map: &String.to_integer/1},
        {:secret_key_base, "SECRET_KEY_BASE"}
      ]
    }

    config = Vapor.load!(providers)

    Application.put_env(:socket_busket, SocketBusketWeb.Endpoint,
      http: [port: config.port],
      secret_key_base: config.secret_key_base,
      pubsub: [name: SocketBusket.PubSub, adapter: Phoenix.PubSub.PG2]
    )
  end
end
