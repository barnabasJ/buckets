defmodule Buckets.Tracking.Bucket do
  use Ash.Resource,
    domain: Buckets.Tracking,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  graphql do
    type :bucket

    queries do
      list :buckets, :read
    end

    mutations do
      create :new_bucket, :create
    end

    subscriptions do
      pubsub BucketsWeb.Endpoint

      subscribe :bucket_created do
        actions :create
        read_action :read
      end

      subscribe :bucket_common_filter do
        action_types [:create, :read, :update]
        actor fn _ -> nil end
        read_action :read_common
      end

      subscribe :bucket_updated do
        actions :update
        read_action :read
      end
    end
  end

  postgres do
    table "bucket"

    repo Buckets.Repo
  end

  actions do
    default_accept :*
    defaults [:read, :update, :destroy]

    read :read_common

    create :create do
      primary? true

      change fn changeset, %{actor: actor} = context ->
        changeset
        |> Ash.Changeset.change_attribute(:user_id, Map.get(actor || %{}, :id))
      end
    end
  end

  policies do
    policy always() do
      authorize_if always()
    end

    policy action(:read) do
      authorize_if expr(user_id == ^actor(:id))
    end

    policy action(:read_common) do
      authorize_if expr(not is_nil(user_id))
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      public? true
      allow_nil? false
    end

    attribute :schedule, Buckets.Tracking.Schedule do
      public? true
      allow_nil? false
    end
  end

  relationships do
    has_many :entries, Buckets.Tracking.Entry do
      sort from: :desc
    end

    has_many :finished_entries, Buckets.Tracking.Entry do
      filter expr(not is_nil(to))
      sort from: :desc
    end

    has_one :current_entry, Buckets.Tracking.Entry do
      from_many? true
      filter expr(is_nil(to))
    end

    belongs_to :user, Buckets.Accounts.User do
      allow_nil? false
    end
  end

  calculations do
    calculate :current_duration,
              :integer,
              expr(
                sum(entries,
                  field: :duration,
                  query: [filter: expr(fragment("?::date = ?", from, today()))]
                ) || 0
              )

    calculate :duration,
              :integer,
              expr(sum(entries, field: :duration) || 0)
  end
end
