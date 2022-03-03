defmodule Spirit.Accounts.User do
  use Spirit, :schema
  alias Spirit.Accounts

  @mutable_fields [
    :pubkey,
    :name,
    :locked,
    :trust,
    :image,
    :banner,
    :description,
    :website,
    :twitter,
    :discord
  ]

  @required_fields [:pubkey, :name]

  @primary_key false
  schema "users" do
    field :id, :binary_id, primary_key: true
    field :pubkey, :string
    field :name, :string
    field :locked, :boolean

    field :image, :string
    field :banner, :string
    field :description, :string
    field :website, :string
    field :twitter, :string
    field :discord, :string

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

    has_one :email, Accounts.Email, references: :id, foreign_key: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @mutable_fields)
    |> validate_required(@required_fields)
    |> validate_length(:pubkey, max: 44)
    |> validate_format_base58(:pubkey)
    |> unique_constraint(:pubkey)
    |> validate_length(:name, max: 50)
    |> validate_length(:image, max: 120)
    |> validate_length(:banner, max: 120)
    |> validate_length(:description, max: 160)
    |> validate_length(:website, max: 100)
    |> validate_link(:website)
    |> validate_length(:twitter, max: 100)
    |> validate_link_twitter(:twitter)
    |> validate_format_discord(:discord)
  end
end
