defmodule Wallet.Deposited do
  @derive Jason.Encoder
  defstruct [:id, :amount]
end
