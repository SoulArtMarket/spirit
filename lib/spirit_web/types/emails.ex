defmodule SpiritWeb.Types.Emails do
  @moduledoc """
  Emails schema.
  """

  use SpiritWeb, :types

  @desc "A registered email"
  object :email do
    field :id, non_null(:id)
    field :address, non_null(:string)
    field :verified, non_null(:boolean)
    field :notify_item_sold, non_null(:boolean)
    field :notify_bid_activity, non_null(:boolean)
    field :notify_price_change, non_null(:boolean)
    field :notify_auction_expiration, non_null(:boolean)
    field :notify_outbid, non_null(:boolean)
    field :notify_successful_purchase, non_null(:boolean)
    field :notify_newsletter, non_null(:boolean)
    field :bid_threshold, non_null(:float)
    field :bid_unit, non_null(:currency)
  end

  object :email_mutations do
    @desc "Register an email"
    field :create_email, :email do
      @desc "User ID"
      arg :id, non_null(:id)
      arg :address, non_null(:string)
      middleware Middleware.Auth, :user
      resolve &Resolvers.Emails.create/2
    end

    @desc "Update an email"
    field :update_email, :email do
      @desc "User ID"
      arg :id, non_null(:id)
      arg :address, :string
      arg :notify_item_sold, :boolean
      arg :notify_bid_activity, :boolean
      arg :notify_price_change, :boolean
      arg :notify_auction_expiration, :boolean
      arg :notify_outbid, :boolean
      arg :notify_successful_purchase, :boolean
      arg :notify_newsletter, :boolean
      arg :bid_threshold, :float
      arg :bid_unit, :currency
      middleware Middleware.Auth, :user
      resolve &Resolvers.Emails.update/2
    end

    @desc "Verify an email"
    field :verify_email, :email do
      arg :address, non_null(:string)
      middleware Middleware.Auth, :email
      resolve &Resolvers.Emails.verify/2
    end

    @desc "Delete an email"
    field :delete_email, :email do
      @desc "User ID"
      arg :id, non_null(:id)
      middleware Middleware.Auth, :user
      resolve &Resolvers.Emails.delete/2
    end
  end
end
