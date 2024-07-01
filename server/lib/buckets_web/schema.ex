defmodule BucketsWeb.Schema do
  use Absinthe.Schema

  @domains [Buckets.Tracking]

  use AshGraphql, domains: @domains

  query do
  end

  mutation do
  end

  subscription do
    #   field :new_bucket, :bucket do
    #     config(fn _, _ ->
    #       IO.inspect("new_bucket")
    #       {:ok, topic: "*"}
    #     end)
    #   end
  end
end
