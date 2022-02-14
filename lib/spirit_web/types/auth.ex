defmodule SpiritWeb.Types.Auth do
  @moduledoc """
  Authentication schema.
  """

  @max_complexity Application.fetch_env!(:spirit, :max_complexity)

  use SpiritWeb, :types

  object :auth_queries do
    @desc "Request a challenge"
    field :challenge, :string do
      arg :pubkey, non_null(:string)
      complexity fn _, _ -> @max_complexity end
      resolve &Resolvers.Auth.challenge/2
    end
  end

  object :auth_mutations do
    @desc "Submit a response"
    field :response, :string do
      arg :pubkey, non_null(:string)
      arg :nonce, non_null(:integer)
      complexity fn _, _ -> @max_complexity end
      resolve &Resolvers.Auth.verify/3
    end
  end
end
