defmodule Spirit.Accounts.User do
  use Spirit, :schema

  @primary_key false
  schema "users" do
    field :id, :binary_id, primary_key: true
    field :pubkey, :string
    field :name, :string
    field :locked, :boolean

    field :trust, Ecto.Enum,
      values: [
        # The account has been confirmed to be a malicious user.
        :malicious,
        # Our system has flagged the user as acting unusual.
        :suspicious,
        # The account is new and has not been flagged.
        :unknown,
        # Our system has flagged the user as active and acting normally.
        :trusted,
        # The account has been confirmed to be trusted.
        :verified,
        # The account has been confirmed to belong to an important user.
        :vip,
        # The account belongs to the admin team.
        :admin
      ]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:pubkey, :name, :locked, :trust])
    |> validate_required([:pubkey, :name])
    |> validate_length(:pubkey, min: 30, max: 100, count: :bytes)
    |> validate_format_base58(:pubkey)
    |> validate_length(:name, max: 50)
    # This check is applied so that names including emojis don't accidentally
    # extend past the set column size.
    |> validate_length(:name, max: 255, count: :bytes)
    |> unique_constraint(:pubkey)
  end
end
