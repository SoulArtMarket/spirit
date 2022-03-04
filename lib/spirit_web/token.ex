defmodule SpiritWeb.Token do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(iss: "spirit", skip: [:aud])
    |> add_claim("role", nil, &(&1 in ["admin", "user", "pubkey", "email"]))
  end
end
