defmodule Wallet.Router do
  use Commanded.Commands.Router

  alias Wallet.Commands

  identify(Wallet.Wallet, by: :id)

  dispatch([
      Commands.CreateWallet,
      Commands.DepositMoney,
      Commands.WithdrawMoney,
      Commands.Transfer
  ], to: Wallet.Wallet)
end
