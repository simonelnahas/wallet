defmodule Wallet.Wallet do
  @enforce_keys [:id]
  defstruct [:id, :balance]

  def execute(%Wallet.Wallet{id: nil}, %Wallet.CreateWallet{id: id}) do
    %Wallet.WalletCreated{id: id}
  end

  def execute(%Wallet.Wallet{}, %Wallet.CreateWallet{}) do
     {:error, :already_created}
  end

  

  def apply(%Wallet.Wallet{} = wallet, %Wallet.WalletCreated{id: id}) do
    %Wallet.Wallet{wallet | id: id, balance: 0}
  end

end
