defmodule WalletTest do
  use ExUnit.Case
  doctest Wallet

  test "greets the world" do
    assert Wallet.hello() == :world
  end
end
