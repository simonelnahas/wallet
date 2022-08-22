defmodule Wallet.BalanceHandler do
  use Commanded.Event.Handler,
     application: Wallet.Application,
     name: __MODULE__

   def init do
     with {:ok, _pid} <- Agent.start_link(fn -> 0 end, name: __MODULE__) do
       :ok
     end
   end

   def handle(%Wallet.WalletCreated{}, _metadata) do
     Agent.update(__MODULE__, fn _ -> 0 end)
   end

   def current_balance do
     Agent.get(__MODULE__, fn balance -> balance end)
   end
end
