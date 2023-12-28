defmodule Buckets.Repo do
  use Ecto.Repo,
    otp_app: :buckets,
    adapter: Ecto.Adapters.Postgres
end
