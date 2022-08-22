defmodule Wallet.Router do
  use Commanded.Commands.Router

  identify Wallet.Wallet, by: :id

  dispatch Wallet.CreateWallet, to: Wallet.Wallet
  dispatch Wallet.Deposit, to: Wallet.Wallet
  dispatch Wallet.Transfer, to: Wallet.Wallet
end
