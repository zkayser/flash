defmodule Flash.Repo.Migrations.CreateTopicsTable do
  use Ecto.Migration

  def change do
    create table("topics") do
      add(:name, :string, null: false)

      timestamps()
    end

    create(unique_index("topics", :name))

    flush()

    alter table("decks") do
      add(:topic_id, references("topics"), null: false)
    end
  end
end
