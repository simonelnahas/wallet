defmodule WalletTest do
  use ExUnit.Case
  use InMemoryEventStoreCase
  import Commanded.Assertions.EventAssertions

  doctest Wallet

  test "CreateWallet results in WalletCreated" do
    :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: 5})

    assert_receive_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      assert event.id == 5
    end)
  end

  test "creating to wallets with same id fails" do
    assert :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: 5})
    assert {:error, :already_created} = Wallet.Application.dispatch(%Wallet.CreateWallet{id: 5})
  end

end
