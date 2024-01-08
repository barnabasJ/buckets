defmodule BucketsWeb.Schema do
  use Absinthe.Schema

  @apis [Buckets.Tracking]

  use AshGraphql, apis: @apis

  query do
  end

  mutation do
  end

  subscription do
    field :new_bucket, :bucket do
      config fn _, _ ->
        {:ok, topic: "*"}
      end

      resolve fn _, _ ->
        {:ok, %{}}
      end
    end
  end
end
