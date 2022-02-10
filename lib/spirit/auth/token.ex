defmodule Spirit.Auth.Token do
  use Spirit, :schema

  schema "tokens" do
    field :jti, :string
    field :uses, :integer
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:jti, :uses])
    |> validate_required([:jti, :uses])
    |> validate_length(:jti, max: 50, count: :codepoints)
    |> validate_number(:uses, greater_than_or_equal_to: 0)
    |> unique_constraint(:jti)
  end
end
