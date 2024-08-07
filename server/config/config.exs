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
config :buckets, ash_domains: [Buckets.Tracking, Buckets.Accounts]

# Error Message
# When the 1.0 version of ash_graphql is released, the default will be changed to `:datetime`, and this error message will
# no longer be shown (but any configuration set will be retained indefinitely).
#
# can be removed after next major release of ash_graphql
config :ash, :utc_datetime_type, :datetime

# AshGraphql
# https://hexdocs.pm/ash_graphql/getting-started-with-graphql.html#add-some-backwards-compatibility-configuration
config :ash_graphql, :default_managed_relationship_type_name_template, :action_name
# https://hexdocs.pm/ash_graphql/use-json-with-graphql.html
config :ash_graphql, :json_type, :json

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
