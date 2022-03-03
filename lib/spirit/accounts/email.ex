defmodule Spirit.Accounts.Email do
  use Spirit, :schema
  alias Spirit.Accounts

  @mutable_fields [
    :address,
    :user_id,
    :verified,
    :notify_item_sold,
    :notify_bid_activity,
    :notify_price_change,
    :notify_auction_expiration,
    :notify_outbid,
    :notify_successful_purchase,
    :notify_newsletter,
    :bid_threshold,
    :bid_unit
  ]

  @required_fields [:address]

  schema "emails" do
    field :address, :string
    field :verified, :boolean

    field :notify_item_sold, :boolean
    field :notify_bid_activity, :boolean
    field :notify_price_change, :boolean
    field :notify_auction_expiration, :boolean
    field :notify_outbid, :boolean
    field :notify_successful_purchase, :boolean
    field :notify_newsletter, :boolean

    field :bid_threshold, :float
    field :bid_unit, Ecto.Enum, values: [:sol, :usd]

    belongs_to :user, Accounts.User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, @mutable_fields)
    |> validate_required(@required_fields)
    |> validate_length(:address, max: 254)
    |> validate_format_email(:address)
    |> unique_constraint(:address)
    |> unique_constraint(:user_id, message: "already has a registered email")
    |> validate_number(:bid_threshold, greater_than_or_equal_to: 0)
  end
end
