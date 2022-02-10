defmodule SpiritWeb.Types.Auth do
  @moduledoc """
  Authentication schema.
  """

  use SpiritWeb, :types

  object :auth_queries do
    @desc "Request a challenge"
    field :challenge, :string do
      arg :pubkey, non_null(:string)
      resolve &Resolvers.Auth.challenge/2
    end
  end

  object :auth_mutations do
    @desc "Submit a response"
    field :response, :string do
      arg :pubkey, non_null(:string)
      arg :nonce, non_null(:integer)
      resolve &Resolvers.Auth.verify/3
    end
  end
end
