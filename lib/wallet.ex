defmodule Wallet do
  use Application

  def start(_type, _args) do
    Wallet.Supervisor.start_link(nil)
  end

end
