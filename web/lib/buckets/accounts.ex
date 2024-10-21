defmodule Buckets.Accounts do
  use Ash.Domain, extensions: [AshGraphql.Domain]

  alias Buckets.Accounts

  graphql do
    queries do
      get Accounts.User, :sign_in, :sign_in_with_password do
        identity false
        type_name :sign_in_user
      end
    end

    mutations do
      create Accounts.User, :register, :register_with_password
    end
  end

  resources do
    resource Accounts.Token
    resource Accounts.User
  end
end

