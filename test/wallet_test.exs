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
    wallet_id = "5"
    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})
    assert {:error, :already_created} = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})
  end

  test "balance of new wallet is 0" do
    wallet_id = "5"

    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: wallet_id})
    wait_for_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      assert event.id == wallet_id
    end)

    assert Aggregate.aggregate_state(Wallet.Application, Wallet.Wallet, wallet_id) == %Wallet.Wallet{
      id: wallet_id,
      balance: 0
    }
  end

end
