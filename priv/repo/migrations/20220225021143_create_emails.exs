defmodule Spirit.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE TYPE currency AS ENUM (
        'sol',
        'usd'
      )
      """,
      "DROP TYPE currency"
    )

    create table(:emails, primary_key: false) do
      add :id, references(:users, type: :uuid, on_delete: :delete_all, validate: true),
        primary_key: true,
        null: false

      add :address, :string, size: 254, null: false
      add :verified, :boolean, null: false, default: false

      add :notify_item_sold, :boolean, null: false, default: true
      add :notify_bid_activity, :boolean, null: false, default: true
      add :notify_price_change, :boolean, null: false, default: true
      add :notify_auction_expiration, :boolean, null: false, default: true
      add :notify_outbid, :boolean, null: false, default: true
      add :notify_successful_purchase, :boolean, null: false, default: true
      add :notify_newsletter, :boolean, null: false, default: true

      add :bid_threshold, :float, null: false, default: 0.1
      add :bid_unit, :currency, null: false, default: "sol"

      timestamps()
    end

    create unique_index(:emails, [:address])

    create constraint(:emails, :bid_threshold_must_be_nonnegative,
             check: "bid_threshold >= 0"
           )
  end
end
