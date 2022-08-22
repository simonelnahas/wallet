defmodule Wallet.Router do
  use Commanded.Commands.Router

  identify Wallet.Wallet, by: :id

  dispatch Wallet.CreateWallet, to: Wallet.Wallet
end
