defmodule Buckets.Tracking.Bucket do
  use Ash.Resource, data_layer: AshPostgres.DataLayer, extensions: [AshGraphql.Resource]

  postgres do
    table "bucket"

    repo Buckets.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end
  end

  graphql do
    type :bucket

    queries do
      list :buckets, :read
    end

    mutations do
      create :new_bucket, :create
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end
end
