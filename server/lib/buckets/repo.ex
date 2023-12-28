defmodule Buckets.Repo do
  use AshPostgres.Repo,
    otp_app: :buckets,
    adapter: Ecto.Adapters.Postgres
end
