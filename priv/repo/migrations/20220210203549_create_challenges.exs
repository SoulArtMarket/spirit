defmodule Spirit.Repo.Migrations.CreateChallenges do
  use Ecto.Migration

  def change do
    create table(:challenges) do
      add :message, :string, size: 24, null: false
      add :pubkey, :string, size: 44, null: false

      timestamps()
    end

    create unique_index(:challenges, [:message])
    create unique_index(:challenges, [:pubkey])

    create constraint(:challenges, :message_must_be_128_bits,
             check: "octet_length(message) = 24"
           )
  end
end
