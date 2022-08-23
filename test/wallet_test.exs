defmodule WalletTest do
  use ExUnit.Case
  use InMemoryEventStoreCase
  import Commanded.Assertions.EventAssertions
  alias Commanded.Aggregates.Aggregate

  doctest Wallet


  ### Create Wallet ###

  test "CreateWallet results in WalletCreated" do
    wallet_id = "5"
    :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id})

    assert_receive_event(Wallet.Application, Wallet.Events.WalletCreated, fn event ->
      assert event.id == wallet_id
    end)
  end

  test "creating to wallets with same id fails" do
    wallet_id = "42"
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id})

    assert {:error, :already_created} =
             Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id})
  end

  test "balance of new wallet is 0" do
    wallet_id = "42"

    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id})

    assert %Wallet.Wallet{
             id: wallet_id,
             balance: 0
           } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id)
  end




  ### Deposits ###

  test "deposit to wallet" do
    wallet_id = "42"

    # Create wallet
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id})

    # Deposit to wallet
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.DepositMoney{id: wallet_id, amount: 242})

    assert %Wallet.Wallet{
             id: wallet_id,
             balance: 242
           } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id)
  end

  test "depositing to one of two wallets" do
    # Create wallets for Alice and Bob
    wallet_id_alice = "42"
    wallet_id_bob = "24"
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id_alice})
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id_bob})


    # Deposit to Alice 242
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.DepositMoney{id: wallet_id_alice, amount: 242})

    # Alice has 242
    assert %Wallet.Wallet{
             id: wallet_id_alice,
             balance: 242
           } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id_alice)

    # Bob still has 0
    assert %Wallet.Wallet{
             id: wallet_id_bob,
             balance: 0
           } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id_bob)
  end

  test "two subsequent deposits to same wallet" do
    wallet_id = "42"

    # create wallet
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id})

    # Deposit 242
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.DepositMoney{id: wallet_id, amount: 242})

    # Deposit 100
    assert :ok = Wallet.Application.dispatch(%Wallet.Commands.DepositMoney{id: wallet_id, amount: 100})

    # Balance is 342
    assert %Wallet.Wallet{
             id: wallet_id,
             balance: 342
           } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id)
  end


  ### Withdrawals ###

  test "withdraw from wallet" do
    wallet_id = "42"

    # # create wallet
    # assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id})

    # # Deposit 242
    # assert :ok = Wallet.Application.dispatch(%Wallet.Commands.DepositMoney{id: wallet_id, amount: 242})

    # # Withdraw 42
    # assert :ok = Wallet.Application.dispatch(%Wallet.Commands.WithdrawMoney{id: wallet_id, amount: 42})

    # # Balance is 200
    # assert %Wallet.Wallet{
    #   id: wallet_id,
    #   balance: 200
    # } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id)




  end


  ### Transfers ###
  # test "Transferring 100 from Alice to Bob" do

  #   # Create wallets for Alice and Bob
  #   wallet_id_alice = "42"
  #   wallet_id_bob = "24"
  #   assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id_alice})
  #   assert :ok = Wallet.Application.dispatch(%Wallet.Commands.CreateWallet{id: wallet_id_bob})

  #   # Deposit to Alice 242
  #   assert :ok = Wallet.Application.dispatch(%Wallet.Commands.DepositMoney{id: wallet_id_alice, amount: 242})

  #   # Transfer 100 from Alice to Bob
  #   assert :ok = Wallet.Application.dispatch(%Wallet.Commands.Transfer{from_id: wallet_id_alice, to_id: wallet_id_bob, amount: 100})

  #   # Alice has 142
  #   assert %Wallet.Wallet{
  #     id: wallet_id_alice,
  #     balance: 142
  #   } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id_alice)

  #   # Bob has 100
  #   assert %Wallet.Wallet{
  #         id: wallet_id_bob,
  #         balance: 100
  #       } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id_bob)


  # end

end
