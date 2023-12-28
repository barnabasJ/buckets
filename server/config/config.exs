# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :buckets,
  ecto_repos: [Buckets.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :buckets, BucketsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: BucketsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Buckets.PubSub,
  live_view: [signing_salt: "DxXXCzN4"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :buckets, Buckets.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Ash
config :buckets, ash_apis: [Buckets.Tracking]

# AshGraphql
# https://hexdocs.pm/ash_graphql/getting-started-with-graphql.html#add-some-backwards-compatibility-configuration
config :ash_graphql, :default_managed_relationship_type_name_template, :action_name

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
