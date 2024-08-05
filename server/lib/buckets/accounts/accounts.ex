defmodule Buckets.Accounts do
  use Ash.Domain, extensions: [AshGraphql.Domain]
  alias Buckets.Accounts

  resources do
    resource Accounts.User
    resource Accounts.Token
  end

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
end
