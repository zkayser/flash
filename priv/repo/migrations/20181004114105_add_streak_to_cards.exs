defmodule Flash.Repo.Migrations.AddStreakToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :streak, :integer, default: 0
    end
  end
end
