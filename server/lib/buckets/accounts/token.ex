defmodule Buckets.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource, AshGraphql.Resource],
    # If using policies, enable the policy authorizer:
    # authorizers: [Ash.Policy.Authorizer],
    domain: Buckets.Accounts

  postgres do
    table "tokens"
    repo Buckets.Repo
  end

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end

  graphql do
    type :token
  end
end
