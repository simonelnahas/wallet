defmodule Wallet.Events.MoneyWithdrawn do
  @derive Jason.Encoder
  defstruct [:id, :amount]
end
