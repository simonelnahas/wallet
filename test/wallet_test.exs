defmodule WalletTest do
  use ExUnit.Case
  use InMemoryEventStoreCase
  import Commanded.Assertions.EventAssertions

  doctest Wallet

  test "ensure any event of this type is published" do
    :ok = Wallet.Application.dispatch(%Wallet.CreateWallet{id: 5})

    assert_receive_event(Wallet.Application, Wallet.WalletCreated, fn event ->
      assert event.id == 5
    end)
  end
end
