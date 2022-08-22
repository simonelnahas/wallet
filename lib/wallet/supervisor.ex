defmodule Wallet.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Application
      Wallet.Application,

      # # Event handler
      # Wallet.BalanceHandler,

      # # Process manager
      # TransferMoneyProcessManager,

      # # Read model projector
      # AccountsProjector,

      # # Optionally, provide runtime configuration
      # {WelcomeEmailHandler, start_from: :current}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
