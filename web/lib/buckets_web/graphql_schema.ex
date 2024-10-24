defmodule BucketsWeb.GraphqlSchema do
  use Absinthe.Schema

  use AshGraphql,
    domains: [Buckets.Accounts, Buckets.Tracking]

  import_types Absinthe.Plug.Types

  query do
    # Custom Absinthe queries can be placed here
  end

  mutation do
    # Custom Absinthe mutations can be placed here
  end

  subscription do
    # Custom Absinthe subscriptions can be placed here
  end
end
