defmodule Wallet.Wallet do
  @enforce_keys [:id]
  defstruct [:id, :balance]

  alias Wallet.Commands
  alias Wallet.Events
  alias Wallet.Wallet

  ### Public API ###

  # Create Wallet
  def execute(%Wallet{id: nil}, %Commands.CreateWallet{id: id}) do
    %Events.WalletCreated{id: id}
  end

  def execute(%Wallet{}, %Commands.CreateWallet{}) do
    {:error, :already_created}
  end



  # Deposit Money
  def execute(%Wallet{}, %Commands.DepositMoney{id: id, amount: amount}) do
    %Events.MoneyDeposited{id: id, amount: amount}
  end



  # Withdraw Money
  def execute(%Wallet{id: nil}, _command) do
    {:error, :wallet_does_not_exist}
  end

  def execute(%Wallet{balance: balance}, %Commands.WithdrawMoney{
        amount: amount
      })
      when balance < amount do
    {:error, :insufficient_balance}
  end

  def execute(%Wallet{id: id}, %Commands.WithdrawMoney{id: id, amount: amount}) do
    %Events.MoneyWithdrawn{id: id, amount: amount}
  end



  # Transfer
  # def execute(%Wallet{}, %Commands.Transfer{from_id: from_id, to_id: to_id, amount: amount}) do
  #   #TODO check if there is enough money in account
  #   #TODO
  # end

  ### State mutators ###

  # Wallet Created
  def apply(%Wallet{} = wallet, %Events.WalletCreated{id: id}) do
    %Wallet{wallet | id: id, balance: 0}
  end

  # Money Deposited
  def apply(%Wallet{} = wallet, %Events.MoneyDeposited{amount: amount}) do
    %Wallet{wallet | balance: wallet.balance + amount}
  end

  # Money Withdrawn
  def apply(%Wallet{} = wallet, %Events.MoneyWithdrawn{amount: amount}) do
    %Wallet{wallet | balance: wallet.balance - amount}
  end

  # Transferred
  # TODO
end
