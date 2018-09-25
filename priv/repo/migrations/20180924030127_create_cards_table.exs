defmodule Flash.Repo.Migrations.CreateCardsTable do
  use Ecto.Migration

  def change do
    create table("cards") do
      add(:front, :string)
      add(:back, :string)
      add(:successes, :integer)
      add(:failures, :integer)
      add(:times_seen, :integer)
      add(:next_review, :naive_datetime)
      add(:last_review, :naive_datetime)

      timestamps()
    end
  end
end
