defmodule Wallet.Router do
  use Commanded.Commands.Router

  identify Wallet.Wallet, by: :id

  dispatch Wallet.Commands.CreateWallet, to: Wallet.Wallet
  dispatch Wallet.Commands.DepositMoney, to: Wallet.Wallet
  dispatch Wallet.Commands.Transfer, to: Wallet.Wallet
end
