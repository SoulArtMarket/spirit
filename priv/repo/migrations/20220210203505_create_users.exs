defmodule Spirit.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE TYPE account_trust AS ENUM (
        'malicious',
        'suspicious',
        'unknown',
        'trusted',
        'verified',
        'vip',
        'admin'
      )
      """,
      "DROP TYPE account_trust"
    )

    create table(:users, primary_key: false) do
      add :id, :uuid,
        primary_key: true,
        null: false,
        default: fragment("gen_random_uuid()")

      add :pubkey, :string, size: 44, null: false
      add :name, :string, size: 50, null: false
      add :locked, :boolean, null: false, default: false
      add :trust, :account_trust, null: false, default: "unknown"

      timestamps()
    end

    create unique_index(:users, [:pubkey])
  end
end
