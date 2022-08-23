defmodule Wallet.Events.MoneyDeposited do
  @derive Jason.Encoder
  defstruct [:id, :amount]
end
