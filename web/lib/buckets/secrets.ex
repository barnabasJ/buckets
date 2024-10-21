defmodule Buckets.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Buckets.Accounts.User, _opts) do
    Application.fetch_env(:buckets, :token_signing_secret)
  end
end
