defmodule Spirit.Repo.Migrations.UsersAddCustomizationFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :image, :string, size: 120
      add :banner, :string, size: 120
      add :description, :string, size: 160
      add :website, :string, size: 100
      add :twitter, :string, size: 100
      add :discord, :string, size: 37
    end
  end
end
