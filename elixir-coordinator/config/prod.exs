import Config

config :logger, level: :info

config :coordinator,
  work_generation_interval: 10_000,
  redundancy: 3,
  quorum: 2
