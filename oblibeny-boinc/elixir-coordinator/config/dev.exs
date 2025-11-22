import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :coordinator,
  work_generation_interval: 5_000,
  redundancy: 3,
  quorum: 2
