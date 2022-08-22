defmodule Wallet.Application do
  use Commanded.Application,
    otp_app: :wallet,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Wallet.EventStore
    ]
    router(Wallet.Router)
end
