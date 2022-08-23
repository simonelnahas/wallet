defmodule Wallet.Events.Transferred do
  defstruct [:from_id, :to_id, :amount]
end
