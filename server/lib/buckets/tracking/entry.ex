defmodule Buckets.Tracking.Entry do
  use Ash.Resource, data_layer: AshPostgres.DataLayer, extensions: [AshGraphql.Resource]

  postgres do
    table "bucket_entry"
    repo Buckets.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :bucket_id, :uuid do
      allow_nil? false
    end

    attribute :from, :utc_datetime do
      allow_nil? false
    end

    attribute :to, :utc_datetime do
    end
  end

  calculations do
    calculate :duration, :integer, expr(fragment("EXTRACT(EPOCH FROM COALESCE(?, NOW()) - ?) / 60", to, from))
  end

  relationships do
    belongs_to :bucket, Buckets.Tracking.Bucket
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  graphql do
    type :bucket_entry
  end
end
