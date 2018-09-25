defmodule Flash.Repo.Migrations.AddDeckIdToCards do
  use Ecto.Migration

  def change do
    alter table("cards") do
      add(:deck_id, references("decks"), null: false)
    end
  end
end
