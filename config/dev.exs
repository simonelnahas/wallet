import Config

config :wallet, event_stores: [Wallet.EventStore]

config :wallet, Wallet.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "eventstore_dev",
  hostname: "localhost",
  port: "5432",
  pool_size: 10
