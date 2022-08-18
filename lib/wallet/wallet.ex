defmodule Wallet.Wallet do
  defstruct [:id, :balance]

  def execute(%Wallet.Wallet{id: nil}, %Wallet.CreateWallet{id: id}) do
    %Wallet.WalletCreated{id: id}
  end

  def apply(%Wallet.Wallet{} = wallet, %Wallet.WalletCreated{} = event) do
    %Wallet.WalletCreated{id: id} = event
    %Wallet.Wallet{wallet | id: id}
  end

end
