defmodule Wallet.Wallet do
  @enforce_keys [:id]
  defstruct [:id, :balance]

  ### Public API ###

  # Create Wallet
  def execute(%Wallet.Wallet{id: nil}, %Wallet.Commands.CreateWallet{id: id}) do
    %Wallet.Events.WalletCreated{id: id}
  end

  def execute(%Wallet.Wallet{}, %Wallet.Commands.CreateWallet{}) do
     {:error, :already_created}
  end

  # Deposit
  def execute(%Wallet.Wallet{}, %Wallet.Commands.DepositMoney{id: id, amount: amount}) do
    %Wallet.Events.MoneyDeposited{id: id, amount: amount}
  end

  # Transfer
  # def execute(%Wallet.Wallet{}, %Wallet.Commands.Transfer{from_id: from_id, to_id: to_id, amount: amount}) do
  #   #TODO check if there is enough money in account
  #   #TODO
  # end




  ### State mutators ###

  # Wallet Created
  def apply(%Wallet.Wallet{} = wallet, %Wallet.Events.WalletCreated{id: id}) do
    %Wallet.Wallet{wallet | id: id, balance: 0}
  end


  # Deposited
  def apply(%Wallet.Wallet{} = wallet, %Wallet.Events.MoneyDeposited{id: id, amount: amount}) do
    %Wallet.Wallet{wallet | id: id, balance: wallet.balance + amount}
  end

  # Transfered
  #TODO


end
