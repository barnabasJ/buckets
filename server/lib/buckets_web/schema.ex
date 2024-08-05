defmodule BucketsWeb.Schema do
  use Absinthe.Schema

  @domains [Buckets.Tracking, Buckets.Accounts]

  use AshGraphql, domains: @domains

  query do
  end

  mutation do
  end

  subscription do
  end
end
