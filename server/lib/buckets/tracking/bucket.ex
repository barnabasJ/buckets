defmodule Buckets.Tracking.Bucket do
  use Ash.Resource,
    domain: Buckets.Tracking,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("bucket")

    repo(Buckets.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      public?(true)
      allow_nil?(false)
    end

    attribute :schedule, Buckets.Tracking.Schedule do
      public? true
      allow_nil?(false)
    end
  end

  relationships do
    has_many(:entries, Buckets.Tracking.Entry)
  end

  policies do
    policy always() do
      authorize_if always()
    end

    # policy action_type(:read) do
    #   authorize_if expr(not is_nil(id))
    # end
  end

  graphql do
    type(:bucket)

    queries do
      list(:buckets, :read)
    end

    mutations do
      create(:new_bucket, :create)
    end

    subscriptions do
      pubsub(BucketsWeb.Endpoint)
      subscribe(:bucket_created)
    end
  end

  calculations do
    calculate(
      :current_duration,
      :integer,
      expr(
        sum(entries,
          field: :duration,
          query: [filter: expr(fragment("?::date = ?", from, today()))]
        )
      )
    )
  end

  actions do
    default_accept :*
    defaults([:create, :read, :update, :destroy])
  end
end
