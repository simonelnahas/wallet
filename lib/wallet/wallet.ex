defmodule Wallet.Wallet do
  @enforce_keys [:id]
  defstruct [:id, :balance]

  ### Public API ###

  # Create Wallet
  def execute(%Wallet.Wallet{id: nil}, %Wallet.CreateWallet{id: id}) do
    %Wallet.WalletCreated{id: id}
  end

  def execute(%Wallet.Wallet{}, %Wallet.CreateWallet{}) do
     {:error, :already_created}
  end

  # Deposit
  def execute(%Wallet.Wallet{}, %Wallet.Deposit{id: id, amount: amount}) do
    %Wallet.Deposited{id: id, amount: amount}
  end

  # Transfer
  def execute(%Wallet.Wallet{}, %Wallet.Transfer{from_id: from_id, to_id: to_id, amount: amount}) do
    #TODO check if there is enough money in account
    #TODO
  end




  ### State mutators ###

  # Wallet Created
  def apply(%Wallet.Wallet{} = wallet, %Wallet.WalletCreated{id: id}) do
    %Wallet.Wallet{wallet | id: id, balance: 0}
  end


  # Deposited
  def apply(%Wallet.Wallet{} = wallet, %Wallet.Deposited{id: id, amount: amount}) do
    %Wallet.Wallet{wallet | id: id, balance: wallet.balance + amount}
  end

  # Transfered
  #TODO


end
