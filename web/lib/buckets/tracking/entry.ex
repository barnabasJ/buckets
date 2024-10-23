defmodule Buckets.Tracking.Entry do
  use Ash.Resource,
    domain: Buckets.Tracking,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  require Ash.Query

  graphql do
    type :bucket_entry
  end

  postgres do
    table "bucket_entry"
    repo Buckets.Repo
  end

  actions do
    defaults [:create, :read, :destroy]

    create :start do
      accept [:bucket_id, :description]

      change before_action(fn changeset, context ->
               bucket_id = Ash.Changeset.get_attribute(changeset, :bucket_id)

               case __MODULE__
                    |> Ash.Query.filter(is_nil(to) and bucket_id == ^bucket_id)
                    |> Ash.Query.for_read(:read, %{}, Ash.Context.to_opts(context))
                    |> Ash.read_one() do
                 {:ok, nil} ->
                   changeset

                 {:ok, entry} ->
                   entry
                   |> Ash.Changeset.for_update(:stop, %{}, Ash.Context.to_opts(context))
                   |> Ash.update!()

                   changeset

                 {:error, error} ->
                   Ash.Changeset.add_error(changeset, error)
               end
             end)

      change before_action(fn changeset, _context ->
               changeset
               |> Ash.Changeset.change_attribute(:from, DateTime.utc_now())
             end)
    end

    update :update do
      primary? true

      accept [:description]
    end

    update :stop do
      accept [:description]

      validate attributes_absent(:to)

      change atomic_update(:to, expr(now()))
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :bucket_id, :uuid do
      allow_nil? false
    end

    attribute :description, :string

    attribute :from, :utc_datetime do
      allow_nil? false
    end

    attribute :to, :utc_datetime do
    end

    timestamps()
  end

  relationships do
    belongs_to :bucket, Buckets.Tracking.Bucket
  end

  calculations do
    calculate :duration,
              :integer,
              expr(fragment("EXTRACT(EPOCH FROM COALESCE(?, NOW()) - ?) / 60", to, from))
  end
end
