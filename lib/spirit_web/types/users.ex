defmodule SpiritWeb.Types.Users do
  @moduledoc """
  Users schema.
  """

  use SpiritWeb, :types
  alias Spirit.Accounts

  connection node_type: :user_account

  @desc "A user account"
  object :user_account do
    field :id, non_null(:id)
    field :pubkey, non_null(:string)
    field :name, non_null(:string)
    field :description, :string, do: complexity(Complexity.weight(6))

    field :email, :email do
      middleware Middleware.Auth, :user
      complexity Complexity.weight(5)
      resolve dataloader(Accounts)
    end

    field :image, :string
    field :banner, :string
    field :website, :string
    field :twitter, :string
    field :discord, :string
    field :locked, non_null(:boolean)
    field :trust, non_null(:account_trust)
    field :inserted_at, non_null(:naive_datetime)
    field :updated_at, non_null(:naive_datetime)
  end

  @desc "A sortable field for a user"
  enum :user_sort_field do
    value :id
    value :name
    value :inserted_at
    value :updated_at
  end

  object :user_queries do
    @desc "Get a user account"
    field :user, :user_account do
      arg :id, :id
      arg :pubkey, :string
      resolve &Resolvers.Users.find/2
    end

    @desc "Get a paginated list of users"
    connection field :users, node_type: :user_account do
      arg :trust, :account_trust
      arg :order_by, list_of(:user_sort_field)
      arg :direction, :sort_direction
      complexity Complexity.pagination()
      resolve &Resolvers.Users.list/2
    end
  end

  object :user_mutations do
    @desc "Create a new user"
    field :create_user, :user_account do
      arg :name, non_null(:string)
      arg :pubkey, non_null(:string)
      middleware Middleware.Auth, :pubkey
      resolve &Resolvers.Users.create/2
    end

    @desc "Update a user"
    field :update_user, :user_account do
      arg :id, non_null(:id)
      arg :name, :string
      arg :description, :string
      arg :image, :string
      arg :banner, :string
      arg :website, :string
      arg :twitter, :string
      arg :discord, :string
      middleware Middleware.Auth, :user
      resolve &Resolvers.Users.update/2
    end

    @desc "Update user trust"
    field :update_user_trust, :user_account do
      arg :id, non_null(:id)
      arg :trust, non_null(:account_trust)
      middleware Middleware.Auth, :admin
      resolve &Resolvers.Users.update/2
    end

    @desc "Lock a user account"
    field :lock_user, :user_account do
      arg :id, non_null(:id)
      middleware Middleware.Auth, :admin
      resolve &Resolvers.Users.lock/2
    end

    @desc "Unlock a user account"
    field :unlock_user, :user_account do
      arg :id, non_null(:id)
      middleware Middleware.Auth, :admin
      resolve &Resolvers.Users.unlock/2
    end

    @desc "Delete a user"
    field :delete_user, :user_account do
      arg :id, non_null(:id)
      middleware Middleware.Auth, :user
      resolve &Resolvers.Users.delete/2
    end
  end
end
