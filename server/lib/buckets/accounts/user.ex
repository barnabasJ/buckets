defmodule Buckets.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer],
    domain: Buckets.Accounts

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false, public?: true
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    strategies do
      password :password do
        identity_field :email
      end
    end

    tokens do
      enabled? true
      token_resource Buckets.Accounts.Token

      signing_secret fn _, _ ->
        Application.fetch_env(:buckets, :token_signing_secret)
      end
    end
  end

  postgres do
    table "users"
    repo Buckets.Repo
  end

  identities do
    identity :unique_email, [:email]
  end

  actions do
    defaults [:read]
  end

  @auth_actions [
    :register_with_password,
    :sign_in_with_password
  ]

  # You can customize this if you wish, but this is a safe default that
  # only allows user data to be interacted with via AshAuthentication.
  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    bypass action(@auth_actions) do
      authorize_if always()
    end

    policy action_type(:read) do
      forbid_if always()
    end
  end

  graphql do
    type :user
  end
end
