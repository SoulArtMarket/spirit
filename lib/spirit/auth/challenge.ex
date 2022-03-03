defmodule Spirit.Auth.Challenge do
  use Spirit, :schema

  schema "challenges" do
    field :message, :string
    field :pubkey, :string

    timestamps()
  end

  @doc false
  def changeset(challenge, attrs) do
    challenge
    |> cast(attrs, [:pubkey, :message])
    |> validate_required([:pubkey, :message])
    |> validate_length(:message, is: 24, count: :bytes)
    |> validate_length(:pubkey, max: 44)
    |> validate_format_base58(:pubkey)
    |> unique_constraint(:message)
    |> unique_constraint(:pubkey)
  end
end
