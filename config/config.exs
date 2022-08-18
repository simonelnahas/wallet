import Config

config :wallet, event_stores: [Wallet.EventStore]

import_config "#{config_env()}.exs"
