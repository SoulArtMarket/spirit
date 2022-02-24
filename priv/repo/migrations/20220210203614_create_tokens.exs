defmodule Spirit.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :jti, :string, size: 30, null: false
      add :uses, :integer, null: false, default: 0
    end

    create unique_index(:tokens, [:jti])
    create constraint(:tokens, :uses_must_be_nonnegative, check: "uses >= 0")
  end
end
