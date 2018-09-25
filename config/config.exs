# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :flash,
  ecto_repos: [Flash.Repo]

# Configures the endpoint
config :flash, FlashWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "thMKMzj30X40TAyhRSru1emdVO3Op2bHBqikhjBpNEtb+IhvLQIBhPK6f4H+BgsE",
  render_errors: [view: FlashWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Flash.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
