defmodule WalletTest do
  use ExUnit.Case
  use InMemoryEventStoreCase
  import Commanded.Assertions.EventAssertions
  alias Commanded.Aggregates.Aggregate

  doctest Wallet

  test "CreateWallet results in WalletCreated" do
    wallet_id = "5"
    :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})

    assert_receive_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      assert event.id == wallet_id
    end)
  end

  test "creating to wallets with same id fails" do
    wallet_id = "42"
    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})

    assert {:error, :already_created} =
             Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})
  end

  test "balance of new wallet is 0" do
    wallet_id = "42"

    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})

    wait_for_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      assert event.id == wallet_id
    end)

    assert %Wallet.Wallet{
             id: wallet_id,
             balance: 0
           } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id)
  end

  test "deposit to wallet" do
    wallet_id = "42"

    # Create wallet
    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})

    wait_for_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      assert event.id == wallet_id
    end)

    # Deposit to wallet
    assert :ok = Wallet.Application.dispatch(%Wallet.Deposit{id: wallet_id, amount: 242})

    wait_for_event(Wallet.Application, Wallet.Deposited, fn event ->
      assert event.id == wallet_id and event.amount == 242
    end)

    assert %Wallet.Wallet{
             id: wallet_id,
             balance: 242
           } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id)
  end

  test "depositing to one of two wallets" do
    # Create wallets for Alice and Bob
    wallet_id_alice = "42"
    wallet_id_bob = "24"
    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id_alice})

    wait_for_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      event.id == wallet_id_alice
    end)

    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id_bob})

    wait_for_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      event.id == wallet_id_bob
    end)

    # Deposit to Alice 242
    assert :ok = Wallet.Application.dispatch(%Wallet.Deposit{id: wallet_id_alice, amount: 242})

    wait_for_event(Wallet.Application, Wallet.Deposited, fn event ->
      event.amount == 242
    end)

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
    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})

    wait_for_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      event.id == wallet_id
    end)

    # Deposit 242
    assert :ok = Wallet.Application.dispatch(%Wallet.Deposit{id: wallet_id, amount: 242})

    wait_for_event(Wallet.Application, Wallet.Deposited, fn event ->
      event.amount == 242
    end)

    # Deposit 100
    assert :ok = Wallet.Application.dispatch(%Wallet.Deposit{id: wallet_id, amount: 100})

    wait_for_event(Wallet.Application, Wallet.Deposited, fn event ->
      event.amount == 100
    end)

    # Balance is 342
    assert %Wallet.Wallet{
             id: wallet_id,
             balance: 342
           } = Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id)
  end
end
