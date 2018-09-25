defmodule Flash.Repo.Migrations.CreateDecksTable do
  use Ecto.Migration

  def change do
    create table(:decks) do
      add(:title, :string, null: false)

      timestamps()
    end
  end
end
