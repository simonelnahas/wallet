defmodule Wallet.WalletRouter do
  use Commanded.Commands.Router
  dispatch Wallet.CreateWallet, to: Wallet.Wallet, identity: :id
end
