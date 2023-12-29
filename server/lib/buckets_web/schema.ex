defmodule BucketsWeb.Schema do
  use Absinthe.Schema

  @apis [Buckets.Tracking]

  use AshGraphql, apis: @apis

  query do
  end

  mutation do
  end
end
